import { SyntheticEvent, useState } from "react";
import { AiOutlineEye, AiOutlineEyeInvisible } from "react-icons/ai";
import { Navigate } from "react-router-dom";
import { GetAuth } from "../api/Auth";

import { useAuth } from "../hooks/useAuthStore";

export const LoginPage = () => {
  const { isAuthenticated, setAuth } = useAuth((state) => state);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errorMsg, setErrorMsg] = useState("");
  const [showPwd, setShowPwd] = useState(false);

  if (isAuthenticated) {
    return <Navigate to="/" />;
  }
  const submit = async (e: SyntheticEvent) => {
    e.preventDefault();
    await GetAuth(email, password).then((resp) => {
      console.log({ resp });
      setAuth(true, resp.data.user, resp.data["jwt-token"]);
    }).catch((e) => {
      console.log(e.response);
      setErrorMsg(e.response.data);
    });
  };

  return (
    <div className="flex justify-center p-4">
      <div className="w-1/4 min-w-[300px]">
        <div className="text-2xl py-5">Please Sign in</div>
        <form className="space-y-6" onSubmit={submit}>
          <input
            type="email"
            autoFocus={true}
            className="w-full py-3 px-3 border border-gray-300
              rounded-lg shadow text-xl text-gray-700 transition ease-in-out
              focus:border-blue-600 focus:outline-none
              peer invalid:border-pink-500 invalid:text-pink-600
              focus:invalid:border-pink-500 focus:invalid:ring-pink-500"
            placeholder="Email address"
            onChange={(e) => setEmail(e.target.value)}
          />
          <p className="mt-2 hidden peer-invalid:block text-pink-600 text-sm">
            Please provide a valid email address.
          </p>

          <div className="flex">
            <input
              type={showPwd ? "text" : "password"}
              className="w-full py-3 px-3 border border-gray-300
              rounded-l-lg shadow text-xl text-gray-700 transition ease-in-out
              focus:border-blue-600 focus:outline-none"
              placeholder="Password"
              onChange={(e) => setPassword(e.target.value)}
              autoComplete="on"
            />
            <div
              className="m-auto p-4 rounded-r-lg shadow border border-gray-300
              text-xl cursor-pointer text-gray-400 hover:text-gray-500"
              onClick={() => setShowPwd(!showPwd)}
            >
              {showPwd ? <AiOutlineEye /> : <AiOutlineEyeInvisible />}
            </div>
          </div>
          <button
            type="submit"
            className="w-full py-3 bg-blue-600 text-white font-medium text-lg
            uppercase rounded-lg shadow-md hover:bg-blue-700
            hover:shadow-lg focus:bg-blue-700
            active:bg-blue-800 transition duration-150
            ease-in-out"
            data-mdb-ripple="true"
            data-mdb-ripple-color="light"
          >
            Sign in
          </button>
        </form>
        <span className="w-full flex m-2 justify-center text-lg text-red-500
          font-bold">
          {errorMsg}
        </span>
      </div>
    </div>
  );
};

export default LoginPage;
