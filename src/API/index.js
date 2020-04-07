const URL = 'http://localhost:5000';

export const loadData = (storageType) => {
  return fetch(`${URL}/load_data?storageType=${storageType}`, {
    method: 'GET'
  }).then(res => res.json())
}