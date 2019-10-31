import React from "react";
import Destination from './destination.jsx';

export default class WelcomePage extends React.Component {
  render() {
    return (
      <div className='container'>
        <h1>Welcome to the Fatum Project Memeplex</h1>
        <h2>Choose your destination:</h2>
        <div className='media-list'>
          <Destination description='Fly through a 3D vector space and explore the relationships of all the words in /r/randonauts subreddit posts!'
                      href='#/galaxy/randonauts?cx=3490&cy=-3185&cz=-1304&lx=-0.3336&ly=0.4104&lz=-0.3886&lw=0.7544&ml=150&s=1.75&l=1&v=2019-10-31T00-00-00Z'
                      name='Randonauts'/>
        </div>
      </div>
    );
  }
}
