import React, { PureComponent } from 'react'
import {
  Link
} from "react-router-dom";
import './styles.scss'

class Navigation extends PureComponent {
  render = () => (
    <nav>
      <ul>
        <li>
          <Link to="/">Home</Link>
        </li>
        <li>
          <Link to="/schedule">Schedule</Link>
        </li>
        <li>
          <Link to='/team'>Team</Link>
        </li>
        <li>
          <Link to='/equipment'>Equipment</Link>
        </li>
      </ul>
    </nav>
  )
}

export default Navigation