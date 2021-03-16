import React, { useContext, useState } from "react";
import { useRouter } from "next/router";
import Image from "next/image";
import { i18nContext } from "../../../../utils/i18nContext";
import SkillPanel from "../../../../components/SkillPanel";
import PageWithSkillList from "../../../../components/PageWithSkillList";
import { gql } from "graphql-tag";
import { useMutation, useQuery } from "@apollo/client";
import { useAuth0, withAuthenticationRequired } from "@auth0/auth0-react";
import Loading from "../../../../components/Loading";
import AddOrEditSkillModale from "../../../../components/AddOrEditSkillModale";

type FetchedSkill = {
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
    Skill(
      where: {
        UserSkills: { userEmail: { _eq: $email } }
        _and: { Category: { label: { _eq: $category } } }
      }
    ) {
      id
      name
      UserSkills(order_by: { created_at: desc }, limit: 1) {
        level
      }
      TechnicalAppetites(order_by: { created_at: desc }, limit: 1) {
        level
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
  const [
    addSkill,
    { error: mutationError, loading: mutationLoading, called: mutationCalled },
  ] = useMutation(EDIT_SKILL_MUTATION);
  const onEditClick = (skill: Skill) => {
    setSelectedSkill(skill);
    setEditPanelOpened(true);
  };

  const onEditCancel = () => {
    setSelectedSkill(undefined);
    setEditPanelOpened(false);
  };

  const openModale = () => {
    setModaleOpened(true);
    setEditPanelOpened(false);
    console.log("selectedSkil", selectedSkill);
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

  const { data: skills, refetch } = useQuery<{ Skill: FetchedSkill[] }>(
    SKILLS_AND_APPETITE_QUERY,
    {
      variables: { email: user.email, category },
    }
  );
  if (mutationCalled && !mutationLoading && !mutationError) {
    refetch({ email: user.email, category });
  }
  if (mutationError) {
    console.error("Error adding skill", mutationError);
  }
  if (isLoading || !skills) {
    return <Loading />;
  }

  return (
    <PageWithSkillList
      context={context}
      category={category}
      add={false}
      faded={editPanelOpened}
    >
      <div>
        <div
          className={`z-10 h-screen ${editPanelOpened ? "opacity-25" : ""}`}
          onClick={() => (editPanelOpened ? onEditCancel() : () => {})}
        >
          {skills.Skill.length > 0 ? (
            skills.Skill.map((item) => (
              <SkillPanel
                key={item.name}
                skill={{
                  id: item.id,
                  name: item.name,
                  level: item.UserSkills[0]?.level ?? 0,
                  desire: item.TechnicalAppetites[0]?.level ?? 0,
                  certif: false,
                }}
                onEditClick={onEditClick}
              />
            ))
          ) : (
            <p>No skill added yet</p>
          )}
        </div>
        <div
          className={`absolute inset-x-0 duration-500 z-20 bottom-0 h-${
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
                <span className="px-2">Edit this skill</span>
              </button>
              <button
                className="flex flex-row flex-start p-1 my-2"
                onClick={() => onEditCancel()}
              >
                <Image src="/icons/back-arrow.svg" width="16" height="16" />
                <span className="px-4">Cancel action</span>
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
            <AddOrEditSkillModale
              skill={selectedSkill}
              cancel={() => setModaleOpened(false)}
              callback={editAction}
            />
          ) : (
            <></>
          )}
        </div>
      </div>
    </PageWithSkillList>
  );
};

export default withAuthenticationRequired(ListSkills);
