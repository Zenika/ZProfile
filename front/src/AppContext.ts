import React from "react";
import { AppStateContext } from "./types";

export const appStateContext = React.createContext<AppStateContext>({
  appState: {
    agencies: [],
    initialized: false,
  },
  setAppState: () => {},
});
