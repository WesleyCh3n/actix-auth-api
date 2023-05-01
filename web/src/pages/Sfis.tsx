import { ColumnDef } from "@tanstack/react-table";
import { useMemo, useState } from "react";

import { GetStation, Station } from "../api/Station";
import { AsyncButton } from "../components/Button";
import {
  TableInstance,
  TableLayout,
  TablePagination,
} from "../components/Table";
import { useAuth } from "../hooks/useAuthStore";

type DataType = | Station | number;
export const SfisPage = () => {
  const { token } = useAuth((state) => state);
  const [data, setResult] = useState<DataType[]>([]);

  // TODO:
  const columns = useMemo<ColumnDef<DataType, any>[]>(() => {
    return [
      { header: "ID", accessorKey: "id" },
      { header: "Name", accessorKey: "name" },
      { header: "Description", accessorKey: "description" },
    ];
  }, [data]);

  const table = TableInstance(data, columns);
  return (
    <div>
      <AsyncButton
        content="Get Station"
        onClick={async () => {
          if (token) {
            let objs = await GetStation(token);
            setResult(objs.data);
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
