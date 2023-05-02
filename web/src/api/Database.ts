import { apiPrivate, ApiResponse } from ".";

export type DataBase = Station | Chip;
export type DataBaseStr = "" | "Station" | "Chip";
type RouteMap = {
  [key in DataBaseStr]: string;
};

const DBROUTES: RouteMap = {
  "Station": "/api/station",
  "Chip": "/api/chip",
  "": "this should not be called",
};

export interface Station {
  id: number;
  name: String;
  description: String;
  type_id: number;
  recordmark_id: number;
}

export interface Chip {
  id: number;
  name: String;
  description: String;
  vendor_id: number;
  type_id: number;
  recordmark_id: number;
}

export const GetData = async <T>(token: String, datatype: DataBaseStr) => {
  const reosolved: { data: T[] } = { data: [] };
  await apiPrivate.get<ApiResponse<T>>(DBROUTES[datatype], {
    headers: { Authorization: `Bearer ${token}` },
  }).then((response) => {
    reosolved.data = response.data.results;
    console.log(response.data.results);
  }).catch(e => {
    console.log(e);
  });
  return reosolved;
};
