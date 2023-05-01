import { useEffect, useRef, useState } from "react";
import { AiFillCaretDown } from "react-icons/ai";
import { BiUserCircle } from "react-icons/bi";
import { Link, useLocation } from "react-router-dom";
import { RemoveAuth } from "../api/Auth";

import { useAuth } from "../hooks/useAuthStore";
import { useOnClickOutside } from "../hooks/useOnClickOutside";

const menuItem = [
  {
    title: "SFIS",
    url: "sfis",
  },
  {
    title: "Query",
    url: "query",
  },
  {
    title: "Tools",
    url: "",
    submenu: [
      {
        title: "menu 1",
        url: "menu 1",
      },
      {
        title: "menu 2",
        url: "menu 2",
      },
    ],
  },
];

export const NavBar = () => {
  const [current, setCurrent] = useState(-1);
  const { isAuthenticated } = useAuth((state) => state);
  const location = useLocation();

  useEffect(() => {
    const i = menuItem.findIndex(item => `/${item.url}` == location.pathname);
    setCurrent(i);
  }, [location.pathname]);

  if (!isAuthenticated) {
    return (
      <div className="flex bg-slate-700 py-2 px-4">
        <div className="flex-1">
          <Link to="/" className="text-2xl text-white pr-4">ASRock</Link>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed top-0 w-screen flex items-center bg-slate-700
      py-1 px-4 h-12 z-50">
      <div className="flex items-center space-x-2">
        <Link to="/" className="text-2xl text-white pr-4">
          ASRock
        </Link>
        {menuItem.map((menu, index) => {
          return !menu.submenu
            ? (
              <div key={index}>
                <Link
                  to={menu.url}
                  className={`text-lg text-white px-2 py-1 rounded
                    transition-all hover:bg-slate-500
                    ${(index == current) && "bg-slate-600"}`}
                >
                  {menu.title}
                </Link>
              </div>
            )
            : (
              <div key={index}>
                <button
                  className="peer text-lg text-white px-2 py-1 rounded
                  transition-all hover:bg-slate-500"
                >
                  {menu.title}
                </button>
                <div className="hidden absolute peer-hover:flex hover:flex
                  flex-col bg-slate-700 rounded drop-shadow-2xl">
                  {menu.submenu.map((_menu, _index) => {
                    return (
                      <Link
                        to={_menu.url}
                        key={_index}
                        className="text-lg text-white px-2 py-1 rounded
                        transition-all hover:bg-slate-500"
                      >
                        {_menu.title}
                      </Link>
                    );
                  })}
                </div>
              </div>
            );
        })}
      </div>
      <span className="mx-auto" />
      <DropDown />
    </div>
  );
};

const DropDown = () => {
  const { user, setAuth } = useAuth((state) => state);
  const [isOpen, setIsOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);
  useOnClickOutside(ref, () => setIsOpen(false));
  return (
    <div className="flex flex-row transition-all">
      <div className="text-lg text-white py-1 px-2 ">{user}</div>
      <button
        className="flex items-center rounded hover:bg-slate-600 p-1
        cursor-pointer"
        onClick={() => setIsOpen(!isOpen)}
      >
        <BiUserCircle className="text-2xl text-white" />
        <AiFillCaretDown className="text-xs text-white" />
      </button>
      {isOpen && (
        <div className="relative" ref={ref}>
          <div className="top-9 right-0 absolute bg-slate-700 rounded
          drop-shadow-2xl border border-slate-600">
            <button
              className="py-1 px-4 rounded whitespace-nowrap
              text-white hover:bg-slate-600"
              onClick={async () => {
                await RemoveAuth();
                setAuth(false, undefined, undefined);
              }}
            >
              Sign out
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default NavBar;
