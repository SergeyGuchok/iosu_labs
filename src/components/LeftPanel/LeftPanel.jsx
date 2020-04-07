import React, { PureComponent } from 'react'
import { makeFirstLetterUpperCase } from '../../utils/string'
import './styles.scss'
import {
  STORAGE_TYPE_SCHEDULE,
  STORAGE_TYPE_TEAM,
  STORAGE_TYPE_EQUIPMENT
} from '../../constants'
import ControlButton from "../ControlButton";

class LeftPanel extends PureComponent {
  addTeam = () => {
    console.log('add team')
  }

  manageTeam = () => {
    console.log('manage team')
  }

  removeTeam = () => {
    console.log('remove team')
  }

  manageSchedule = () => {
    console.log('manage schedule')
  }

  manageEquipment = () => {

  }

  addEquipment = () => {

  }

  removeEquipment = () => {

  }

  render = () => {
    const { storageType } = this.props
    return (
      <aside>
        <p className='left_panel_title'>
          {makeFirstLetterUpperCase(this.props.storageType)}
        </p>
        <div>
          {storageType === STORAGE_TYPE_TEAM && <ControlButton onClick={this.addTeam} disabled text='Add Team' />}
          {storageType === STORAGE_TYPE_TEAM && <ControlButton onClick={this.manageTeam} text='Manage Team' />}
          {storageType === STORAGE_TYPE_TEAM && <ControlButton onClick={this.removeTeam} text='Remove Team' />}
          {storageType === STORAGE_TYPE_SCHEDULE && <ControlButton onClick={this.manageSchedule} text='Manage Schedule' />}
          {storageType === STORAGE_TYPE_EQUIPMENT && <ControlButton onClick={this.manageEquipment} text='Manage Equipment' />}
          {storageType === STORAGE_TYPE_EQUIPMENT && <ControlButton onClick={this.addEquipment} text='Add Equipment' />}
          {storageType === STORAGE_TYPE_EQUIPMENT && <ControlButton onClick={this.removeEquipment} text='Remove Equipment' />}
        </div>
      </aside>
    )
  }
}

export default LeftPanel