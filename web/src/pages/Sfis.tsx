import { ColumnDef } from "@tanstack/react-table";
import { useMemo, useState } from "react";

import { DataBase, DataBaseStr, GetData, Station, Chip } from "../api/Database";
import { AsyncButton } from "../components/Button";
import {
  TableInstance,
  TableLayout,
  TablePagination,
} from "../components/Table";
import { useAuth } from "../hooks/useAuthStore";

export const SfisPage = () => {
  const { token } = useAuth((state) => state);
  const [data, setData] = useState<DataBase[]>([]);
  const [dataType, setDataType] = useState<DataBaseStr>("");

  // TODO:
  const columns = useMemo<ColumnDef<DataBase, any>[]>(() => {
    const default_col = [
      { header: "ID", accessorKey: "id" },
      { header: "Name", accessorKey: "name" },
      { header: "Description", accessorKey: "description" },
    ];
    if (dataType === "Station") {
      return [
        { header: "ID", accessorKey: "id" },
        { header: "Name", accessorKey: "name" },
        { header: "Description", accessorKey: "description" },
      ];
    } else if (dataType === "Chip") {
      return [
        { header: "ID", accessorKey: "id" },
        { header: "Vendor ID", accessorKey: "vendor_id" },
        { header: "Name", accessorKey: "name" },
        { header: "Description", accessorKey: "description" },
      ];
    }
    return default_col;
  }, [dataType]);

  const table = TableInstance(data, columns);
  return (
    <div>
      <AsyncButton
        className="mx-2"
        content="Get Station"
        onClick={async () => {
          if (token) {
            let result = await GetData<Station>(token, "Station");
            setData(result.data);
            setDataType("Station");
            table.setPageSize(20);
          }
        }}
      />
      <AsyncButton
        className="mx-2"
        content="Get Chip"
        onClick={async () => {
          if (token) {
            let objs = await GetData<Chip>(token, "Chip");
            setData(objs.data);
            setDataType("Chip");
            table.setPageSize(20);
          }
        }}
      />
      <div className="h-2"></div>
      <TableLayout table={table} />
      <div className="h-2" />
      <TablePagination table={table} />
    </div>
  );
};
