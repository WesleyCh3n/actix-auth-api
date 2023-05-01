import { ColumnDef } from "@tanstack/react-table";
import { useMemo, useState } from "react";
import { SiPostgresql } from "react-icons/si";

import { DeviceInfo, GetDeviceInfo } from "../api/DeviceInfoAPI";
import { AsyncButton } from "../components/Button";
import {
  TableInstance,
  TableLayout,
  TablePagination,
} from "../components/Table";

export const QueryPage = () => {
  const [data, setData] = useState<DeviceInfo[]>([]);

  const columns = useMemo<ColumnDef<DeviceInfo, any>[]>(() => [
    { header: "Class", accessorKey: "class" },
    { header: "Enumerator", accessorKey: "enumerator" },
    { header: "Description", accessorKey: "description" },
    { header: "Manufacturer", accessorKey: "manufacturer" },
    { header: "Hardware ID", accessorKey: "hardware_id" },
    { header: "Compatible ID", accessorKey: "compatible_id" },
    { header: "Class GUID", accessorKey: "class_guid" },
  ], []);

  const table = TableInstance(data, columns);

  return (
    <div className="">
      <div className="flex items-center mb-4 gap-2 border p-2 rounded-lg m-auto
        max-w-[300px] border-slate-300">
        <SiPostgresql size={25} className="text-slate-600 mr-5" />
        <AsyncButton
          className=""
          content={"Device Info"}
          onClick={async () => {
            const promise = await GetDeviceInfo();
            const data = promise.data as DeviceInfo[];
            setData(data);
            table.setPageSize(20);
            let uniqueObjArray = [
              ...new Map(
                (promise.data as DeviceInfo[]).map((
                  item,
                ) => [item.enumerator, item]),
              ).values(),
            ];
            console.log(uniqueObjArray);
          }}
        />
        <div className="m-auto"></div>
        <AsyncButton
          className="self-end"
          content={"Clear"}
          onClick={() => setData([])}
        />
      </div>
      <div className="max-w-[98vw] max-h-[75vh] overflow-scroll ">
        <TableLayout table={table} />
      </div>
      <div className="h-2" />
      <TablePagination table={table} />
    </div>
  );
};
