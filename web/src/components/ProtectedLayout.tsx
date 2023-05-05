import { Layout, Menu, theme } from "antd";
import { Link, Navigate, useLocation, useOutlet } from "react-router-dom";
const { Header, Content } = Layout;

import { useAuth } from "../hooks/useAuthStore";

export const ProtectedLayout = () => {
  const location = useLocation();
  const { isAuthenticated, user } = useAuth();
  const outlet = useOutlet();
  const {
    token: { colorBgContainer },
  } = theme.useToken();

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
      </div>
    );

  return (
    <Layout style={{ height: "100vh" }}>
      <Header style={{ height: "60px" }}>
        <Menu
          theme="dark"
          mode="horizontal"
          selectable={false}
          style={{ height: "60px" }}
          items={[
            {
              label: (
                <Link to="/" className="font-bold text-2xl">
                  ASRock
                </Link>
              ),
              key: "0",
              style: { color: "white" },
            },
            { label: <Link to="sfis">SFIS</Link>, key: "1" },
          ]}
        />
      </Header>
      <Content>
        <div className="m-4 p-4" style={{ background: colorBgContainer }}>
          {onThisPage}
          {outlet}
        </div>
      </Content>
    </Layout>
  );
};
