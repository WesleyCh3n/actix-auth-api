import { apiPrivate, ApiResponse } from ".";

export interface Station {
  id: number;
  name: String;
  description: String;
  type_id: number;
  recordmark_id: number;
  type: "Station";
}

export const GetStation = async (token: String) => {
  const reosolved: { data: Station[] } = { data: [] };
  await apiPrivate.get<ApiResponse<Station>>("/api/station", {
    headers: { Authorization: `Bearer ${token}` },
  }).then((response) => {
    reosolved.data = response.data.results;
    console.log(response.data.results);
  }).catch(e => {
    console.log(e);
  });
  return reosolved;
};
