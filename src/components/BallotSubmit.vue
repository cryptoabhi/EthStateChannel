<template>
  <div class="item">
    <div class="copy">
      <h2>Conclude Votes</h2>
      <p>
        This will end you voting session, and reveal your answers to the
        network.
      </p>
      <div class="actions">
        <button class="btn btn-primary" @click="submit">Finish</button>
      </div>
    </div>
  </div>
</template>

<script>
// Category: City planning
const topic = {
  id: 1,
  q: 'City lights are old, upgrade to LED?'
}

export default {
  name: 'BallotSubmit',

  data() {
    return {
      topic
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

.item {
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
}

.copy {
  h2 {
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    margin: 0 0 5px;
  }
}

.btn {
  display: block;
  min-width: 120px;
}

.actions {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}
</style>
