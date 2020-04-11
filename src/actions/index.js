export const LOAD_DATA_ACTION_TYPE = 'LOAD_DATA';
export const DATA_FETCHING_ACTION_TYPE = 'FETCHING'
export const DATA_FETCHING_ENDED_ACTION_TYPE = 'FETCHING_ENDED'
export const CHECK_FIELD_ACTION_TYPE = 'CHECK_FIELD'

export const loadDataAction = (data, storageType) => ({
  type: LOAD_DATA_ACTION_TYPE,
  data,
  storageType,
})

export const selectFieldCheckedForStorage = (field, isChecked, storageType) => ({
  type: CHECK_FIELD_ACTION_TYPE,
  field,
  isChecked,
  storageType,
})

export const dataFetching = () => ({
  type: DATA_FETCHING_ACTION_TYPE
})

export const dataFetchingEnded = () => ({
  type: DATA_FETCHING_ENDED_ACTION_TYPE,
})
