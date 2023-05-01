import { useState } from "react";
import { AiOutlineMenu } from "react-icons/ai";
import { HiTemplate } from "react-icons/hi";

export const SideBar = () => {
  const [isOpen, setIsOpen] = useState(false);
  return (
    <>
      <div
        className={`absolute h-screen bg-red-400 z-20 duration-200
${isOpen ? "w-60" : "w-16"}`}
      >
        <div className="flex items-center">
          <AiOutlineMenu
            className="ml-3 mt-2 text-white text-4xl cursor-pointer"
            onClick={() => setIsOpen(() => !isOpen)}
          />
        </div>
        <div className="flex items-center ml-3 mt-4">
          <HiTemplate
            href="upload"
            className="block float-left text-white text-4xl cursor-pointer"
          />
          <div className={`${!isOpen ? "hidden" : ""}`}>some text</div>
        </div>
      </div>
      <div
        className={`duration-300 h-screen w-screen bg-black
${isOpen ? "absolute opacity-30 z-10 " : "opacity-0"}`}
        onClick={() => setIsOpen(!isOpen)}
      />
    </>
  );
};
