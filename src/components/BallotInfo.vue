<template>
  <div class="list-item">
    <div class="copy">
      <h2>Ballot 37 - City Upgrades</h2>
      <p>Cast Your Vote! Join {{ totalBallotUsers }} other voters.</p>
      <h3>Topics:</h3>
      <ol>
        <li v-for="item in topics">{{ item }}</li>
      </ol>
    </div>
    <button class="btn btn-primary" @click="startBallot">Join Ballot</button>
  </div>
</template>

<script>
// Category: City planning
const topics = [
  'City lights are old, upgrade to LED?',
  'Trash cycle is once a week, change to twice?',
  'City should add a new school?',
  'City should add a new grocery store?',
  'City should provide free wifi?'
]

export default {
  name: 'BallotInfo',

  data() {
    return {
      totalBallotUsers: 3,
      topics
    }
  },

  methods: {
    startBallot() {
      console.log('TODO: startBallot')
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../scss/variables.scss';

.list-item {
  background: $white;
  border-radius: $border-radius;
  box-shadow: 0 1px 7px -2px rgba(0, 0, 0, 0.3);
  padding: 20px;
  width: 33vw;
  margin: 0 auto 10px;
  max-width: 500px;
  min-width: 180px;
  display: flex;
  flex-direction: column;

  .btn {
    display: block;
    margin: auto;
    min-width: 200px;
  }
}

.copy {
  h2 {
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    margin: 0 0 5px;
  }

  h2,
  p {
    text-align: center;
  }
}
</style>
