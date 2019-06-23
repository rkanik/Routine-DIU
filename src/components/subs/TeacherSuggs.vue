<template>
<div class="teacher-suggs">
    <div class="list-group text-left">
        <button 
            type="button" 
            class="list-group-item list-group-item-action"  
            v-for="index in suggs.length" 
            v-bind:key=index
            @click="OnClickSuggItem(index-1)">{{suggs[index-1]}}
        </button>
    </div>
</div>
</template>
<script>
/** IMPORTS */
import  {bus}   from "../../main"

export default {
    name:'TeacherSuggs',
    props:{
        suggs:Array
    },
    methods:{
        OnClickSuggItem(index){bus.$emit('SearchedKey',this.suggs[index])}
    }
}
</script>
<style lang="scss" scoped>
    .teacher-suggs{
        width: 24rem;margin: 0 auto;
        margin-top: 0.5rem;
        position: absolute;
        left: 0;right: 0;
        z-index: 10;
    }
    .list-group{
        .list-group-item{
            background-color: #313131;
            color: #9e9e9e;
            border-color: #2c2c2c;
            padding-bottom: 0.5rem;
            padding-top: 0.5rem
        }
        .list-group-item:hover{
            background-color: #2c2c2c;
        }
    }
</style>