<template>
    <div class="sidebar bg-teal-7 position-relative">
        <div class="d-block h-25 w-100">
        </div>
        <div class="tab-container">
            <ul>
                <li v-bind:class="{active:active=='Students'}" @click="onTabSelected('Students')">Students</li>
                <li v-bind:class="{active:active=='Routines'}" @click="onTabSelected('Routines')">Routines</li>
                <li>Courses</li>
                <li>Teachers</li>
                <hr>
                <li>Settings</li>
                <li>About</li>
            </ul>
        </div>
    </div>
</template>

<script>

/** IMPORTS */
import { bus } from "../../main";


/** COMPONENTS */

export default {
    name:'Sidebar',
    props:{

    },
    components:{
        
    },
    data(){
        return{

            /** Booleans */

            /** Objects */

            /** Arrays */

            /** Strings */
            active:'Students'
        }
    },
    created(){

    },
    methods:{
        onTabSelected( tab ){
            this.active = tab;
            bus.$emit('SelectedTab', tab );
        }
    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>
    .sidebar{
        width: 13rem;
        height: 100vh;
        position: relative;
        transition: all 0.3s ease-in-out;
    }
    .tab-container{
        ul{
            padding-left: 0;
            text-align: left;
            li{
                color: #e0e0e0;
                list-style-type: none;
                margin: 0.1rem 1rem;
                padding: 0.3rem 1rem;
                border-radius: 2rem;
                cursor: pointer;
                font-weight: 300;
                transition: background-color 0.4s ease-in-out;
                user-select: none;
            }
            li:hover,.active{
                background-color:#00695c; 
            }
        }
    }
</style>
