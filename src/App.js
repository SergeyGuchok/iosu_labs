import React, { PureComponent } from 'react';
import { connect } from 'react-redux';
import Header from './components/Header'
import LeftPanel from "./components/LeftPanel";
import Table from "./components/Table";
import {
  BrowserRouter as Router,
  Switch,
  Route
} from "react-router-dom";
import {
  STORAGE_TYPE_TEAM,
  STORAGE_TYPE_SCHEDULE,
  STORAGE_TYPE_HOME,
  STORAGE_TYPE_EQUIPMENT
} from './constants'
import './styles.scss'

class App extends PureComponent {

  render = () => {
    return (
      <Router>
        <Header />
        <hr />
        <main>
          <Switch>
            <Route path='/' exact>
              <LeftPanel storageType={STORAGE_TYPE_HOME} />
              <Table storageType={STORAGE_TYPE_HOME} />
            </Route>
            <Route path='/schedule' exact>
              <LeftPanel storageType={STORAGE_TYPE_SCHEDULE} />
              <Table storageType={STORAGE_TYPE_SCHEDULE} />
            </Route>
            <Route path='/team' exact>
              <LeftPanel storageType={STORAGE_TYPE_TEAM} />
              <Table storageType={STORAGE_TYPE_TEAM} />
            </Route>
            <Route path='/equipment' exact>
              <LeftPanel storageType={STORAGE_TYPE_EQUIPMENT} />
              <Table storageType={STORAGE_TYPE_EQUIPMENT} />
            </Route>
          </Switch>
        </main>
      </Router>
    )
  }
}

const mapStateToProps = (state) => ({
  schedule: state.schedule,
})

export default connect(mapStateToProps)(App);
