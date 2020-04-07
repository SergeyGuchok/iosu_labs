import React, { PureComponent } from 'react'
import Navigation from "../Navigation/index";
import './styles.scss'
import { Link } from "react-router-dom";

class Header extends PureComponent {
  render = () => (
    <header>
      <div>
        <Link to='/'>
          <h1>Technology Card</h1>
        </Link>
      </div>
      <Navigation/>
    </header>
  )
}

export default Header