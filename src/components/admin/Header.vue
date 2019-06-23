<template>
    <div class="header">
        <div class="container">
            <h4 class="pt-3 app-name">Routine Manager CSE <span class="beta blu-5">ADMIN</span></h4>
            <div class="SignedIn"> 
                <button class="btn btn-outline-danger btn-sm" @click="onClickLogout()">Logout</button>
            </div>
        </div>
    </div>
</template>

<script>

/** IMPORTS */
import { bus } from "../../main";

/** COMPONENTS */

export default {
    name:'Header',
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
        }
    },
    created(){

    },
    methods:{
        onClickLogout(){
            bus.$emit('LogoutAdmin');
        }
    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>
.header{
    height: 4rem;
    background-color: #191919;
    .app-name{
        letter-spacing: 1px;
        font-weight: 400;
        user-select: none;
        float: left;
    }
    .beta{
        font-size: 0.6rem;
    }
}
.SignedIn{
    float: right;
    margin-top: 1rem;
    .lead{
        float: left;
    }
    .btn{
        float: right;
        margin-left: 1rem;
    }
}
</style>
