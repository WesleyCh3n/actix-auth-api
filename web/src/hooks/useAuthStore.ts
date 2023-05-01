import create from "zustand";

interface AuthStore {
  isAuthenticated: boolean;
  user: string | undefined;
  token: string | undefined;
  setAuth: (
    isAuth: boolean,
    user: string | undefined,
    token: string | undefined,
  ) => void;
}

export const useAuth = create<AuthStore>()(
  (set) => ({
    isAuthenticated: false,
    user: undefined,
    token: undefined,
    setAuth: (
      isAuth: boolean,
      user: string | undefined,
      token: string | undefined,
    ) => set(() => ({ isAuthenticated: isAuth, user: user, token: token })),
  }),
);
