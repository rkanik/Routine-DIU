<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<style lang='scss'>
#app {
  font-family: 'Roboto', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #9e9e9e;
}
.text-accent{
    color: #009688;
}

/* width */
::-webkit-scrollbar {
  width: 8px;
}
 
/* Track */
::-webkit-scrollbar-track {
  background: #191919;
}
 
/* Handle */
::-webkit-scrollbar-thumb {
  background: #212121;
}
 
/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #313131;
}

</style>
