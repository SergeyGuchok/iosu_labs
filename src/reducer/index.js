import {
  LOAD_DATA_ACTION_TYPE,
  DATA_FETCHING_ACTION_TYPE,
  DATA_FETCHING_ENDED_ACTION_TYPE,
  CHECK_FIELD_ACTION_TYPE
} from '../actions'

const initialStore = {
  schedule: [],
  equipment: [],
  team: [],
  checkedFields: {
    equipment: [],
    team: [],
  },
  fetching: false,
}

export const reducer = (state = initialStore, action) => {
  switch (action.type) {
    case LOAD_DATA_ACTION_TYPE:
      return {
        ...state,
        [action.storageType.toLowerCase()]: action.data,
      }

    case DATA_FETCHING_ACTION_TYPE:
      return {
        ...state,
        fetching: true,
      }

    case DATA_FETCHING_ENDED_ACTION_TYPE:
      return {
        ...state,
        fetching: false,
      }

    case CHECK_FIELD_ACTION_TYPE:
      const { isChecked, field, storageType } = action;
      const finalState = {
        ...state,
      }

      if (isChecked) {
        finalState.checkedFields[storageType].push(field)
      } else {

      }

    default:
      return state
  }
}