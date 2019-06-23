<template>
    <!-- header start -->
    <div id="header" class="text-left" v-bind:class="{'light-colors':lightTheme}">
        <div class="container">
            <h4 class="pt-3 app-name">Routine Manager CSE <span class="beta blu-5">BETA{{version}}</span></h4>
            <div class="input-group" v-if="!isSignedIn">
                <input type="text" v-model="inputId" class="form-control" placeholder="Student ID" aria-describedby="button-addon2">
                <div class="input-group-append">
                    <button class="btn btn-primary" @click="onClickSignin()" type="button" id="button-addon2">SIGNIN</button>
                </div>
            </div>
            <div v-if="isSignedIn" class="SignedIn"> 
                <p class="lead">{{signedId}}</p>
                <button class="btn btn-outline-danger btn-sm" @click="onClickLogout()">Logout</button>
            </div>
        </div>
    </div>
    <!-- header end-->
</template>

<script>

/** IMPORTS */
import { bus } from "../main";
import pac from "../../package.json";

export default {
    name:'Header',
    data(){
        return{
            signedId:'',inputId:'',
            isSignedIn:false,
            lightTheme:false,
            version:pac.version
        }
    },
    created(){

        /** Fetch Theme **/
        this.FetchTheme();
        bus.$on('ThemeChanged',x=>{this.FixTheme(x)});

        bus.$on('signedData', data =>{this.isSignedIn=true;this.signedId=data.ID;});
        if( localStorage.isSignedIn ){
            this.isSignedIn=true;
            this.signedId=JSON.parse(localStorage.signedData).ID;
        }
    },
    methods:{
        onClickSignin(){
            if( this.inputId.trim()!==''){bus.$emit('showLoading');bus.$emit('SigninStudent',this.inputId.trim());}
        },
        onClickLogout(){
            
            localStorage.removeItem('signedData');
            this.signedId='',this.inputId='',this.isSignedIn=false;
            bus.$emit('loggedOut');
        },
        FixTheme(x){
            this.lightTheme=x;
            localStorage.setItem('Theme',x);
        },
        FetchTheme(){
            if(localStorage.getItem('Theme')!==undefined){
                if(localStorage.getItem('Theme')==='true'){
                this.FixTheme(true)}else{this.FixTheme(false);}   
            }else{this.FixTheme(false)}
        }
    }
}
</script>

<style lang="scss" scoped>
#header{
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
.input-group{
    float: right;
    width: 16rem;
    margin-top: 1rem;
    .form-control,
    .btn-primary{
        height: 2rem;
        font-size: 1em;
        padding: 0.2rem 1rem ;
    }
    .form-control{
        background: transparent;
        border-color: #424242;
        color: #bdbdbd;
    }
    .btn-primary{
        font-size: 0.9em;
        letter-spacing: 1px;
        border-color: #009688;
        background-color: #009688;
    }
    .btn-primary:hover{
        border-color: #00796b;
        background-color: #00796b;
    }
}

// Themeing //
.light-colors{
    background-color: white !important;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.1);
    border: none;
    .app-name{
        color: #313131;
    }
    .lead{
        color: #313131;
    }
    .form-control{
        border-color: #bdbdbd;
        color: #313131;
    }
}
</style>
