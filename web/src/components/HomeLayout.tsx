import { Navigate, useOutlet } from "react-router-dom";
import { Layout } from 'antd';
const { Header, Content } = Layout;

import { useAuth } from "../hooks/useAuthStore";

export const HomeLayout = () => {
  const { isAuthenticated } = useAuth();
  const outlet = useOutlet();

  if (isAuthenticated) {
    return <Navigate to="/" replace />;
  }

  return (
    <Layout style={{ height: "100vh" }}>
      <Header className="items-center">
        <p className="text-white font-bold text-2xl m-4">ASRock</p>
      </Header>
      <Content>
        {outlet}
      </Content>
    </Layout>
  );
};

