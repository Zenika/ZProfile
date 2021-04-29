import { useContext, useEffect, useState } from "react";
import { useRouter } from "next/router";
import Image from "next/image";
import { useMediaQuery } from "react-responsive";
import { i18nContext } from "../../../../utils/i18nContext";
import SkillPanel from "../../../../components/SkillPanel";
import PageWithSkillList from "../../../../components/PageWithSkillList";
import { gql } from "graphql-tag";
import { useMutation, useQuery } from "@apollo/client";
import { useAuth0, withAuthenticationRequired } from "@auth0/auth0-react";
import Loading from "../../../../components/Loading";
import AddOrEditSkillModale from "../../../../components/AddOrEditSkillModale";
import CommonPage from "../../../../components/CommonPage";
import { RadarData } from "../../../../components/Radar";

export type FetchedSkill = {
  id: string;
  name: string;
  UserSkills: {
    level: number;
  }[];
  TechnicalAppetites: {
    level: number;
  }[];
};

export type Skill = {
  id: string;
  name: string;
  level: number;
  desire: number;
  certif: boolean;
};

const EDIT_SKILL_MUTATION = gql`
  mutation addUserSkill(
    $email: String!
    $skillId: uuid!
    $level: Int!
    $desire: Int!
  ) {
    insert_UserSkill(
      objects: { skillId: $skillId, level: $level, userEmail: $email }
      on_conflict: { constraint: UserSkill_pkey, update_columns: level }
    ) {
      affected_rows
    }
    insert_TechnicalAppetite(
      objects: { skillId: $skillId, level: $desire, userEmail: $email }
      on_conflict: { constraint: TechnicalAppetite_pkey, update_columns: level }
    ) {
      affected_rows
    }
  }
`;

const SKILLS_AND_APPETITE_QUERY = gql`
  query getSkillsAndTechnicalAppetitesByCategory(
    $email: String!
    $category: String!
  ) {
    Category(where: { label: { _eq: $category } }) {
      color
      Skills(
        where: {
          UserSkills: { userEmail: { _eq: $email } }
          _and: { Category: { label: { _eq: $category } } }
        }
      ) {
        id
        name
        UserSkills(
          order_by: { created_at: desc }
          limit: 1
          where: { userEmail: { _eq: $email } }
        ) {
          level
        }
        TechnicalAppetites(
          order_by: { created_at: desc }
          limit: 1
          where: { userEmail: { _eq: $email } }
        ) {
          level
        }
      }
    }
  }
`;

const ZENIKA_SKILLS_QUERY = gql`
  query getSkillsAndTechnicalAppetites($category: String!) {
    Category(order_by: { index: asc }, where: { label: { _eq: $category } }) {
      label
      color
      x
      y
      Skills(where: { UserSkills: { created_at: { _is_null: false } } }) {
        name
        UserSkills_aggregate(order_by: { created_at: desc }) {
          aggregate {
            avg {
              level
            }
          }
        }
        TechnicalAppetites_aggregate(order_by: { created_at: desc }) {
          aggregate {
            avg {
              level
            }
          }
        }
      }
    }
  }
`;

const ListSkills = () => {
  const router = useRouter();
  const { user, isLoading } = useAuth0();
  const { t } = useContext(i18nContext);
  const { context, category } = router.query;
  const [editPanelOpened, setEditPanelOpened] = useState(false);
  const [modaleOpened, setModaleOpened] = useState(false);
  const [selectedSkill, setSelectedSkill] = useState<Skill | undefined>(
    undefined
  );

  const [skills, setSkills] = useState<{
    Category: { color; Skills: FetchedSkill[] };
  }>();
  const [radarData, setRadarData] = useState<RadarData[]>();
  const [sortedSkills, setSortedSkills] = useState<Skill[]>();
  const { data: skillsData, refetch } = useQuery(
    context === "zenika" ? ZENIKA_SKILLS_QUERY : SKILLS_AND_APPETITE_QUERY,
    {
      variables: { email: user.email, category: category || "" },
      fetchPolicy: "network-only",
    }
  );
  useEffect(() => {
    if (!skillsData) {
      return;
    }
    setSkills(skillsData);
    setRadarData(
      skillsData.Category[0].Skills.map((skill) => ({
        x:
          context === "zenika"
            ? skill.UserSkills_aggregate.aggregate.avg.level
            : skill.UserSkills[0].level,
        y:
          context === "zenika"
            ? skill.TechnicalAppetites_aggregate.aggregate.avg.level
            : skill.TechnicalAppetites[0].level,
        weight: 65,
        labels: [skill.name],
        name: skill.name,
      })).sort((a, b) => -(a.x + a.y - (b.x + b.y)))
    );
    setSortedSkills(
      skillsData.Category[0].Skills.map((skill) => ({
        id: skill.id,
        name: skill.name,
        level:
          context === "zenika"
            ? skill.UserSkills_aggregate.aggregate.avg.level
            : skill.UserSkills[0].level ?? 0,
        desire:
          context === "zenika"
            ? skill.TechnicalAppetites_aggregate.aggregate.avg.level
            : skill.TechnicalAppetites[0].level ?? 0,
        certif: false,
      })).sort((a, b) => -(a.level + a.desire - (b.level + b.desire)))
    );
  }, [skillsData]);

  const [addSkill, { error: mutationError }] = useMutation(
    EDIT_SKILL_MUTATION,
    {
      onCompleted: async () => {
        const { data } = await refetch({ email: user.email, category });
        setSkills(data);
      },
    }
  );
  const onEditClick = (skill: Skill) => {
    setSelectedSkill(skill);
    openModale();
    // setEditPanelOpened(true);
  };

  const onEditCancel = () => {
    setSelectedSkill(undefined);
    setEditPanelOpened(false);
  };

  const openModale = () => {
    setModaleOpened(true);
    setEditPanelOpened(false);
  };

  const editAction = ({ id, name, level, desire }) => {
    setModaleOpened(false);
    setSelectedSkill(undefined);
    addSkill({
      variables: {
        skillId: id,
        email: user?.email,
        level,
        desire,
      },
    });
  };
  if (mutationError) {
    console.error("Error adding skill", mutationError);
  }
  if (isLoading || !skills) {
    return <Loading />;
  }
  return (
    <CommonPage page={category} faded={modaleOpened} context={context}>
      <PageWithSkillList
        context={context}
        category={category}
        add={false}
        faded={editPanelOpened || modaleOpened}
        data={radarData}
        color={skills?.Category[0]?.color}
      >
        <div
          className={`z-10 ${
            editPanelOpened || modaleOpened ? "opacity-25" : ""
          }`}
          onClick={() => (editPanelOpened ? onEditCancel() : () => {})}
        >
          {sortedSkills?.length > 0 ? (
            sortedSkills?.map((skill) => (
              <SkillPanel
                key={skill.name}
                skill={skill}
                context={
                  typeof context === "string" ? context : context.join("")
                }
                onEditClick={onEditClick}
              />
            ))
          ) : (
            <p>{t("skills.noSkillAddedYet")}</p>
          )}
        </div>
        <div
          className={`fixed inset-x-0 duration-500 z-20 bottom-0 h-${
            editPanelOpened ? "2/6" : "0"
          } w-8/10 dark:bg-dark-light mx-2 rounded`}
        >
          <div className={`flex flex-col py-6 px-4 justify-between`}>
            <h1 className="text-xl text-bold">{selectedSkill?.name}</h1>
            <div className="flex flex-col h-full mt-8 justify-around ml-2">
              <button
                className="flex flex-row flex-start p-1 my-2"
                onClick={() => openModale()}
              >
                <Image src="/icons/preferences.svg" width="24" height="24" />
                <span className="px-2">{t("skills.editSkill")}</span>
              </button>
              <button
                className="flex flex-row flex-start p-1 my-2"
                onClick={() => onEditCancel()}
              >
                <Image src="/icons/back-arrow.svg" width="16" height="16" />
                <span className="px-4">{t("skills.cancelAction")}</span>
              </button>
            </div>
          </div>
        </div>
        <div
          className={`z-20 fixed inset-y-0 right-0 h-screen w-full ${
            modaleOpened ? "" : "hidden"
          }`}
        >
          {selectedSkill ? (
            <div className="flex flex-row justify-center">
              <AddOrEditSkillModale
                skill={selectedSkill}
                cancel={() => setModaleOpened(false)}
                callback={editAction}
              />
            </div>
          ) : (
            <></>
          )}
        </div>
      </PageWithSkillList>
    </CommonPage>
  );
};

export default withAuthenticationRequired(ListSkills);
