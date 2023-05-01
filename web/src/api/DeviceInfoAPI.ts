import api from ".";

export type DeviceInfo = {
  "class": string,
  "enumerator": string,
  "description": string,
  "manufacturer": string,
  "hardware_id": string,
  "compatible_id": string,
  "class_guid": string
}

export const CreateDeviceInfo = async (data: any) => {
  const resolved = { error: null, status: 0 };
  await api.post("/api/db/devinfo", data, {
    headers: { "Content-Type": "application/json" },
    withCredentials: true,
  }).then((response) => {
    resolved.status = response.status
  }).catch(e => {
    resolved.error = e.response.data;
    resolved.status = e.response.status;
  });

  return resolved;
};

export const GetDeviceInfo = async () => {
  const resolved = { data: [], error: null, status: 0 };
  await api.get("/api/db/devinfo", {
    headers: { "Content-Type": "application/json" },
    withCredentials: true,
  }).then((response) => {
    resolved.status = response.status
    resolved.data = response.data.data
  }).catch(e => {
    resolved.error = e.response.data;
    resolved.status = e.response.status;
  });

  return resolved;
};
