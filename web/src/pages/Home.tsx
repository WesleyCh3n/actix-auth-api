import { Navigate } from "react-router-dom";
import { useAuth } from "../hooks/useAuthStore";

export const Home = () => {
  const { user, isAuthenticated } = useAuth((state) => state);

  if (!isAuthenticated) {
    return <Navigate to="/login" />;
  }

  return <div className="p-3 text-xl">{user ? "Hi " + user : ""}</div>;
};

export default Home;
