import { LOAD_DATA_ACTION_TYPE } from '../actions'
import { DATA_FETCHING_ACTION_TYPE } from '../actions';
import { DATA_FETCHING_ENDED_ACTION_TYPE } from "../actions";

const initialStore = {
  schedule: [],
  equipment: [],
  team: [],
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

    default:
      return state
  }
}