<template>
  <div class="container">
    <h2>Voting Ballots</h2>

    <div class="current-ballots">
      <BallotInfo />
    </div>

    <div class="previous-ballots">
      <BallotTotals />
    </div>

    <div class="questions">
      <BallotQuestion />
      <BallotSubmit />
    </div>
  </div>
</template>

<script>
import BallotInfo from './BallotInfo'
import BallotTotals from './BallotTotals'
import BallotQuestion from './BallotQuestion'
import BallotSubmit from './BallotSubmit'

export default {
  name: 'Home',

  components: {
    BallotInfo,
    BallotTotals,
    BallotQuestion,
    BallotSubmit
  }
}
</script>

<style lang="scss" scoped>
@import '../scss/variables.scss';

.container {
  margin: 20px auto;
}

h2 {
  text-align: center;
}
</style>
