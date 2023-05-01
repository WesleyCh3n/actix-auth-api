import { Navigate, useOutlet } from "react-router-dom";

import { useAuth } from "../hooks/useAuthStore";

export const HomeLayout = () => {
  const { isAuthenticated } = useAuth();
  const outlet = useOutlet();

  if (isAuthenticated) {
    return <Navigate to="/" replace />;
  }

  return (
    <div>
      {outlet}
    </div>
  );
};

