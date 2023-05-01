import { useState } from "react";
import { CreateDeviceInfo } from "../api/DeviceInfoAPI";
import { AsyncButton } from "../components/Button";

export const UploadPage = () => {
  const [file, setFile] = useState("");
  const [errorMsg, setErrorMsg] = useState("");
  const [isFinish, setIsFinish] = useState(false);
  const readFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    setIsFinish(false);
    const fileReader = new FileReader();
    if (e.target.files) {
      fileReader.readAsText(e.target.files[0], "UTF-8");
      fileReader.onload = e => {
        if (e.target?.result) {
          setFile(e.target.result as string);
        }
      };
    }
  };

  return (
    <div className="flex justify-center">
      <div className="w-1/3 min-w-[350px] flex flex-col space-y-2 p-4
      border border-gray-300 rounded-lg">
        <h1 className="text-lg text-center">
          Please Choose Device Info Json File
        </h1>
        <div className="flex">
          <input
            className="flex-1 file:mr-4 file:py-2 file:px-4
              file:rounded-full file:border-0
              file:text-sm file:font-semibold
              file:bg-slate-100 file:text-slate-700
              hover:file:bg-slate-200"
            type="file"
            accept=".json"
            onChange={readFile}
          />
          <AsyncButton
            content={"Upload"}
            onClick={async () => {
              setErrorMsg("");
              const jsonDevInfo = JSON.parse(file.replaceAll("\\", "\\\\"));
              let promise = await CreateDeviceInfo(jsonDevInfo);
              promise.error
                ? setErrorMsg(promise.error as string)
                : setIsFinish(true);
            }}
            disabled={file == ""}
          />
        </div>
        {isFinish && (
          <div className="mx-auto font-bold text-green-400">
            Success!!
          </div>
        )}
        {errorMsg && <span>{errorMsg}</span>}
      </div>
    </div>
  );
};
