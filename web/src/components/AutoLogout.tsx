import { useEffect } from "react";
import { RemoveAuth } from "../api/Auth";
import { useAuth } from "../hooks/useAuthStore";

const events = [
  "load",
  "mousemove",
  "mousedown",
  "click",
  "scroll",
  "keypress",
];

export const AutoLogout = () => {
  const { isAuthenticated, setAuth } = useAuth((state) => state);
  let timer: number;

  useEffect(() => {
    isAuthenticated
      && events.forEach((item) => {
        window.addEventListener(item, () => {
          resetTimer();
          handleLogoutTimer();
        });
      });
  }, [isAuthenticated]);

  const resetTimer = () => {
    if (timer) clearTimeout(timer);
  };

  const handleLogoutTimer = () => {
    timer = setTimeout(() => {
      resetTimer();
      events.forEach((item) => window.removeEventListener(item, resetTimer));
      logoutAction();
    }, 60_000 * 15); // 1000ms = 1secs
  };

  const logoutAction = async () => {
    await RemoveAuth();
    setAuth(false, undefined, undefined);
    window.location.pathname = "/login";
    alert("Please Re-login");
  };

  return <></>;
};

export default AutoLogout;
