import {
  Column,
  ColumnDef,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  SortingState,
  Table,
  useReactTable,
} from "@tanstack/react-table";
import { useState } from "react";
import { BiSort } from "react-icons/bi";
import { BsSortAlphaDown, BsSortAlphaUp } from "react-icons/bs";
import {
  GrCaretNext,
  GrCaretPrevious,
  GrChapterNext,
  GrChapterPrevious,
} from "react-icons/gr";

export const TableInstance = <T,>(
  data: T[],
  columns: ColumnDef<T, any>[],
): Table<T> => {
  const [sorting, setSorting] = useState<SortingState>([]);
  const [columnVisibility, setColumnVisibility] = useState({});

  const table = useReactTable({
    data,
    columns,
    state: {
      sorting,
      columnVisibility,
    },
    onSortingChange: setSorting,
    onColumnVisibilityChange: setColumnVisibility,
    getSortedRowModel: getSortedRowModel(),
    getCoreRowModel: getCoreRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
  });
  return table;
};

export const TableLayout = <T,>(
  props: { table: Table<T> },
) => {
  return (
    <table className="text-sm whitespace-nowrap m-auto">
      <thead>
        {props.table.getHeaderGroups().map(headerGroup => (
          <tr key={headerGroup.id} className="">
            {headerGroup.headers.map(header => (
              <th
                key={header.id}
                className={`sticky top-0 select-none
                    ${header.column.getIsSorted()
                    ? "bg-blue-100"
                    : "bg-slate-200"
                  }`}
                colSpan={header.colSpan}
              >
                <div
                  className="flex justify-center items-center border
                    border-b-2  border-slate-600 cursor-pointer"
                  onClick={header.column.getToggleSortingHandler()}
                >
                  {flexRender(
                    header.column.columnDef.header,
                    header.getContext(),
                  )}
                  {{
                    asc: <BsSortAlphaDown className="text-sm" />,
                    desc: <BsSortAlphaUp className="text-sm" />,
                  }[header.column.getIsSorted() as string] ?? (
                      <BiSort className="text-sm" />
                    )}
                </div>
              </th>
            ))}
          </tr>
        ))}
      </thead>
      <tbody>
        {props.table.getRowModel().rows.map((row) => (
          <tr key={row.id} className="group hover:bg-slate-200 even:bg-sky-100">
            {row.getVisibleCells().map(cell => (
              <td
                key={cell.id}
                className={`px-1 border border-slate-400 group-hover:bg-slate-200
                  ${cell.column.getIsSorted() && "bg-sky-50"}
                  }`}
              >
                {flexRender(cell.column.columnDef.cell, cell.getContext())}
              </td>
            ))}
          </tr>
        ))}
      </tbody>
      <tfoot>
        {props.table.getFooterGroups().map(footerGroup => (
          <tr key={footerGroup.id}>
            {footerGroup.headers.map(header => (
              <th key={header.id} className="sticky bottom-0 bg-slate-100">
                {header.column.getCanFilter()
                  ? (
                    <div className="p-2 flex border border-slate-600 ">
                      <Filter column={header.column} />
                    </div>
                  )
                  : null}
              </th>
            ))}
          </tr>
        ))}
      </tfoot>
    </table>
  );
};

export const TableColumnCheckbox = <T,>(
  props: { table: Table<T> },
) => {
  return (
    <div className="inline-block text-sm">
      <div className="peer p-1 border rounded hover:bg-slate-200">
        Show / Hide Columns
      </div>
      <div className="hidden absolute peer-hover:flex hover:flex flex-col z-10
        border border-slate-300 rounded">
        {props.table.getAllLeafColumns().map(column => {
          return (
            <div key={column.id} className="px-1 bg-sky-50 hover:bg-sky-200">
              <label>
                <>
                  <input
                    {...{
                      type: "checkbox",
                      checked: column.getIsVisible(),
                      onChange: column.getToggleVisibilityHandler(),
                    }}
                  />{" "}
                  {column.columnDef.header}
                </>
              </label>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export const TablePagination = <T,>(
  props: { table: Table<T> },
) => {
  return (
    <div className="flex justify-center items-center gap-2 overflow-scroll">
      <button
        className="border rounded p-1 hover:bg-slate-200 disabled:bg-gray-300"
        onClick={() => props.table.setPageIndex(0)}
        disabled={!props.table.getCanPreviousPage()}
      >
        <GrChapterPrevious className="" />
      </button>
      <button
        className="border rounded p-1 hover:bg-slate-200 disabled:bg-gray-300"
        onClick={() => props.table.previousPage()}
        disabled={!props.table.getCanPreviousPage()}
      >
        <GrCaretPrevious className="" />
      </button>
      <button
        className="border rounded p-1 hover:bg-slate-200 disabled:bg-gray-300"
        onClick={() => props.table.nextPage()}
        disabled={!props.table.getCanNextPage()}
      >
        <GrCaretNext className="" />
      </button>
      <button
        className="border rounded p-1 hover:bg-slate-200 disabled:bg-gray-300"
        onClick={() => props.table.setPageIndex(props.table.getPageCount() - 1)}
        disabled={!props.table.getCanNextPage()}
      >
        <GrChapterNext className="" />
      </button>
      <span className="flex items-center gap-1 text-sm">
        <input
          type="number"
          className="border p-1 rounded w-10 text-center font-bold"
          value={props.table.getState().pagination.pageIndex + 1}
          min={1}
          max={props.table.getPageCount() == 0 ? 1 : props.table.getPageCount()}
          onChange={e => {
            const page = e.target.value ? Number(e.target.value) - 1 : 0;
            props.table.setPageIndex(page);
          }}
        />
        {" to "}
        <strong>
          {props.table.getPageCount() == 0 ? 1 : props.table.getPageCount()}
        </strong>
        {" Page of "}
        <strong>{props.table.getFilteredRowModel().rows.length}</strong>
        {" Results"}
      </span>
      <select
        value={props.table.getState().pagination.pageSize}
        onChange={e => props.table.setPageSize(Number(e.target.value))}
        className="border rounded p-1 hover:bg-slate-200 text-sm"
      >
        {[20, 30, 40, 50].map(pageSize => (
          <option key={pageSize} value={pageSize}>
            Show {pageSize}
          </option>
        ))}
        <option value={props.table.getFilteredRowModel().rows.length}>
          Show All
        </option>
      </select>
      <div>
        <TableColumnCheckbox table={props.table} />
      </div>
    </div>
  );
};

function Filter({
  column,
}: {
  column: Column<any, any>;
}): JSX.Element {
  const columnFilterValue = column.getFilterValue();

  return (
    <input
      type="text"
      value={(columnFilterValue ?? "") as string}
      onChange={e => column.setFilterValue(e.target.value)}
      placeholder={`Search ${column.columnDef.header}...`}
      className={`w-full border border-slate-400 shadow rounded px-1
        placeholder:bg-white focus:border-sky-700 focus:outline-none
        ${column.getFilterValue() ? "bg-orange-200" : "bg-transparent"}`}
    />
  );
}
