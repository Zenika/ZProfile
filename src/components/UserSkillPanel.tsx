import { useContext } from "react";
import Image from "next/image";
import LevelBar from "./LevelBar";
import { i18nContext } from "../utils/i18nContext";
import { useRouter } from "next/router";
import { useDarkMode } from "../utils/darkMode";

type User = { name: string; picture: string; agency: string };
type Skill = {
  id: string;
  name: string;
  level: number;
  user: User;
  desire: number;
  certif: boolean;
};
const UserSkillPanel = ({
  skill,
  context,
}: {
  skill: Skill;
  context: string;
}) => {
  const { t } = useContext(i18nContext);
  const { darkMode } = useDarkMode();
  const { query } = useRouter();
  const { category } = query;
  const { id, name, level, desire, certif } = skill;
  return (
    <div
      className="flex flex-row bg-light-light dark:bg-dark-light px-4 py-4 mx-2 my-1 rounded-lg"
      onClick={() => {}}
    >
      <div
        className={`flex flex-col ${context !== "zenika" ? "w-5/6" : "w-full"}`}
      >
        <div className="flex flex-row justify-start">
          <Image
            className="h-16 w-16 rounded-full"
            height="64"
            width="64"
            src={skill.user.picture || ""}
          />
          <div className="flex flex-col ml-4">
            <div className="flex flex-row">
              <h2 className="text-xl">{skill.user.name}</h2>
              {certif ? (
                <Image
                  src={`/icons/${darkMode ? "dark" : "light"}/certifs.svg`}
                  height="30"
                  width="30"
                />
              ) : (
                <></>
              )}
            </div>
            <h3 className="text-md">
              Zenika {t(`agencies.${skill.user.agency}`)}
            </h3>
          </div>
        </div>
        <div className="flex flex-row justify-around">
          <div className="flex flex-col">
            <p className="text-xs text-center my-2">
              {t("skills.desireLevel")}
            </p>
            <LevelBar color="red" level={desire} />
          </div>
          <div className="flex flex-col">
            <p className="text-xs text-center my-2">{t("skills.skillLevel")}</p>
            <LevelBar color="yellow" level={level} />
          </div>
        </div>
      </div>
      {/* <div className="flex w-1/6 justify-end">
        <Image src={`/icons/${darkMode ? "dark" : "light"}/chevron.svg`} width="8" height="12" />
      </div> */}
    </div>
  );
};

export default UserSkillPanel;
