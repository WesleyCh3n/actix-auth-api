import { BrowserRouter, Route, Routes } from "react-router-dom";

import { HomeLayout, NavBar, ProtectedLayout } from "./components";
import AutoLogout from "./components/AutoLogout";
import { LoginPage, PageNotFound, UploadPage } from "./pages";
import { SfisPage } from "./pages/Sfis";

function App() {
  return (
    <BrowserRouter>
      <NavBar />
      <Routes>
        <Route element={<HomeLayout />}>
          <Route path="/login" element={<LoginPage />} />
        </Route>

        <Route path="/" element={<ProtectedLayout />}>
          <Route path="upload" element={<UploadPage />} />
          <Route path="sfis" element={<SfisPage />} />
        </Route>

        <Route path="*" element={<PageNotFound />} />
      </Routes>
      <AutoLogout />
    </BrowserRouter>
  );
}

export default App;
