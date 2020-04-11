import React, { PureComponent } from 'react'
import { connect } from 'react-redux'
import './styles.scss'
import { loadData } from '../../API'
import { loadDataAction, dataFetching, dataFetchingEnded, selectFieldCheckedForStorage } from "../../actions";
import { STORAGE_TYPE_TEAM, STORAGE_TYPE_EQUIPMENT } from "../../constants";

class Table extends PureComponent {
  state = {
    currentData: [],
  }

  componentDidMount = () => {
    this.props.loadData()
  }

  componentDidUpdate = (prevProps) => {
    console.log(this.props)
    if (prevProps.storageType !== this.props.storageType) {
      this.props.loadData()
    }
  }

  static getDerivedStateFromProps (props) {
    switch (props.storageType) {
      case STORAGE_TYPE_EQUIPMENT:
        return { currentData: props.equipment }

      case STORAGE_TYPE_TEAM:
        console.log(props.team)
        return { currentData: props.team }

      default:
        return { currentData: [] }
    }
  }

  checkElement = (field, e) => {
    console.log(e.target.checked)
  }

  render = () => (
    <section>
      <div className='table-wrapper'>
        {
          this.state.currentData.length ? (
            <table>
              <tbody>
              <tr>
                <th style={{ width: '40px' }}>&nbsp;</th>
                {
                  this.state.currentData[0] &&
                  Object.keys(this.state.currentData[0]).map((key, index) => <th key={index}>{key}</th>)
                }
              </tr>
              {
                this.state.currentData.length && this.state.currentData.map((el, index) => {
                  return (
                    <tr key={index}>
                      <td>
                        <input type="checkbox" onChange={(e) => this.checkElement(el, e)}/>
                      </td>
                      {
                        Object.keys(el).map((key, index) => <td key={index}>{el[key]}</td>)
                      }
                    </tr>
                  )
                })
              }
              </tbody>
            </table>
          ) : (
            <div className="empty-table">
              No Data Here :(
            </div>
          )
        }
        {
          this.props.isFetching && (
            <div className="spinner">
              <i className="fa fa-spinner fa-spin"/>
            </div>
          )
        }
      </div>
    </section>
  )
}

const mapStateToProps = (state) => ({
  schedule: state.schedule,
  equipment: state.equipment,
  team: state.team,
  isFetching: state.fetching,
})

const mergeProps = (stateProps, { dispatch }, ownProps) => ({
  ...stateProps,
  ...ownProps,
  loadData: async () => {
    dispatch(dataFetching())
    const data = await loadData(ownProps.storageType)

    dispatch(loadDataAction(data, ownProps.storageType))
    dispatch(dataFetchingEnded())
  },
  selectField: (field, isChecked) => {
    dispatch(selectFieldCheckedForStorage(field, isChecked, ownProps.storageType))
  }
})

export default connect(mapStateToProps, null, mergeProps)(Table)