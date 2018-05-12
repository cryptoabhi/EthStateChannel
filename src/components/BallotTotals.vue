<template>
  <div class="list-item">
    <div class="copy">
      <h2>Ballot 37 - Response</h2>
      <ol>
        <li v-for="t in topics">
          <h4>{{ t.q }}</h4>
          <div class="numbers">
            <div class="number">{{ t.n }} No</div>
            <div class="number">{{ t.y }} Yes</div>
          </div>
        </li>
      </ol>
    </div>
  </div>
</template>

<script>
// Category: City planning
const topics = [
  {
    y: 1,
    n: 3,
    q: 'City lights are old, upgrade to LED?'
  },
  {
    y: 7,
    n: 2,
    q: 'Trash cycle is once a week, change to twice?'
  },
  {
    y: 3,
    n: 4,
    q: 'City should add a new school?'
  },
  {
    y: 6,
    n: 2,
    q: 'City should add a new grocery store?'
  },
  {
    y: 2,
    n: 0,
    q: 'City should provide free wifi?'
  }
]

export default {
  name: 'BallotTotals',

  data() {
    return {
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

.numbers {
  display: flex;
  justify-content: space-between;
}
</style>
