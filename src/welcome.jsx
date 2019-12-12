import React from "react";
import Destination from './destination.jsx';

export default class WelcomePage extends React.Component {
  render() {
    return (
      <div className='container'>
        <h1>Welcome to the Randonauts Memeplex</h1>
        <h2>Fly through 3D vector space and explore the relationships of all the words</h2>
        <div className='media-list'>
          <Destination description='The main Randonaut community forum with questions, discussions and detailed reports of trips'
                      href='#/galaxy/randonauts?l=1&cz=4000'
                      name='/r/randonauts subreddit'/>
          <Destination description='Trip reports submitted via the bot'
                      href='#/galaxy/randonaut_reports?l=1&cy=-900&cz=5000'
                      name='/r/randonaut_reports subreddit'/>
        </div>
      </div>
    );
  }
}
