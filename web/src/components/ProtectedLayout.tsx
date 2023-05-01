import { Navigate, useLocation, useOutlet } from "react-router-dom";

import { useAuth } from "../hooks/useAuthStore";

export const ProtectedLayout = () => {
  const location = useLocation()
  const { isAuthenticated, user } = useAuth();
  const outlet = useOutlet();

  if (!isAuthenticated) {
    return <Navigate to="/login" />;
  }

  const onThisPage = location.pathname == "/"
    && (
      <div className="p-4 flex h-[80vh] justify-center items-center text-2xl">
        Hello {user}
        <br></br>
        This is home page
        <br></br>
        Nothing to show here right now
      </div >
    )

  return (
    <div className="">
      <div className="h-12"></div>
      <div className="p-4" style={{
      }}>
        {onThisPage}
        {outlet}
      </div>
    </div>
  );
};
