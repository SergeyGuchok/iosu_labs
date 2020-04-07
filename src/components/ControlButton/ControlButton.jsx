import React, { PureComponent } from 'react'
import './styles.scss'

class ControlButton extends PureComponent {
  handleClick = (e) => {
    !this.props.disabled && this.props.onClick(e)
  }

  render = () => (
    <button className={this.props.disabled ? 'disabled' : ''} onClick={this.handleClick}>
      {this.props.text}
    </button>
  )
}

export default ControlButton