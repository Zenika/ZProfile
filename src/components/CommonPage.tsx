import { useContext } from "react";
import Link from "next/link";
import Image from "next/image";
import { useMediaQuery } from "react-responsive";
import { i18nContext } from "../utils/i18nContext";
import Topbar from "./Topbar";
import Notification from "./Notification";
import { useRouter } from "next/router";
import { useDarkMode } from "../utils/darkMode";

type CommonPageProps = {
  children: any;
  page: string | string[];
  faded: boolean;
  context: string | string[];
  category?: string | string[];
  skill?: string;
};

const NEXT_PUBLIC_BASE_URL = process.env.NEXT_PUBLIC_BASE_URL;
if (!NEXT_PUBLIC_BASE_URL) {
  throw new Error(
    "ERROR: App couldn't start because NEXT_PUBLIC_BASE_URL isn't defined"
  );
}

const CommonPage = ({
  children,
  page,
  faded,
  category,
  skill,
  context,
}: CommonPageProps) => {
  const { t } = useContext(i18nContext);
  const { darkMode } = useDarkMode();
  const router = useRouter();
  const { agency } = router.query;
  const isDesktop = useMediaQuery({
    query: "(min-device-width: 1280px)",
  });

  const backUrl = new URL(
    `${NEXT_PUBLIC_BASE_URL}${
      context === "zenika"
        ? skill && category
          ? `/skills/zenika/${category}`
          : "/zenika"
        : "/"
    }`
  );
  if (agency) {
    backUrl.searchParams.append(
      "agency",
      typeof agency === "string" ? agency : agency.join("")
    );
  }
  return (
    <div className="flex flex-row justify-center w-full overflow-y-hidden">
      <div className="flex flex-col w-full">
        {isDesktop ? (
          <div className={faded ? "opacity-25" : ""}>
            <Topbar path={""} togglePanel={() => {}} context={context} />
          </div>
        ) : (
          <></>
        )}
        <div className="flex flex-row justify-center">
          <div className="flex flex-col justify-center bg-light-med dark:bg-dark-med w-full">
            <div className="flex flex-row justify-center w-full my-1 bg-light-light dark:bg-dark-dark">
              <div
                className={`flex flex-row max-w-screen-xl w-full p-6 ${
                  faded ? "opacity-25" : ""
                }`}
              >
                <Link href={backUrl.toString()}>
                  <div className="p-1 cursor-pointer">
                    <Image
                      src={`/icons/${
                        darkMode ? "dark" : "light"
                      }/back-arrow.svg`}
                      width="16"
                      height="16"
                    />
                  </div>
                </Link>
                <h1 className="ml-10 text-xl">
                  {t(`commonPageNav.${page}`) || page}
                </h1>
              </div>
            </div>
            {children}
          </div>
        </div>
      </div>
      <Notification />
    </div>
  );
};

export default CommonPage;
