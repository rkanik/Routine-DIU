<template>
    <!-- sidebar start -->
    <div id="sidebar" class="bg-grey-9 grey-4" v-bind:class="{'sidebar-collapse':!sidebarExpanded,'light-colors':lightTheme}">
        <div class="sidebar-top">
            <div class="back" @click="CollapseAndExpandSidebar()" v-bind:class="{forward:!sidebarExpanded}">
                <img src="../assets/svg/arrow_back.svg">
            </div>
            <div class="box-note text-center">
                <p class="lead">Department of CSE</p>
                <p class="lead">Daffodil International University</p>
                <p>Semester: <strong>Summer 2019</strong></p>
                <p>Campus: <strong>MAIN</strong></p>
                <p>Program: <strong>DAY</strong></p>
            </div>
        </div>
        <hr>
        <div class="sd-con">
            <ul v-bind:class="{'ch-bg-bg-2':lightTheme}">
                <li v-bind:class="{active:active=='Student'}" @click="onSidebarItemSelected('Student')">{{sidebarListItems[0]}}</li>
                <li v-bind:class="{active:active=='Teacher'}" @click="onSidebarItemSelected('Teacher')">Teacher's Routine</li>
                <li v-bind:class="{active:active=='EmptyRoom'}" @click="onSidebarItemSelected('EmptyRoom')">Empty Rooms</li>
                <li v-bind:class="{active:active=='SeatPlan'}" @click="onSidebarItemSelected('SeatPlan')">Seat Plans</li>
                <hr>
                <li v-bind:class="{active:active=='Settings'}" @click="onSidebarItemSelected('Settings')">Settings</li>
                <li v-bind:class="{active:active=='About'}" @click="onSidebarItemSelected('About')">About</li>
            </ul>
        </div>
        <div class="box-note text-center">
            <p class="lead">Routine Version: <strong>V3</strong></p>
        </div>
    </div>
    <!-- sidebar end-->
</template>

<script>

import { bus } from "../main";

export default {
    name:'Sidebar',
    data(){
        return{
            active:'Student',today:new Date().toDateString(),
            sidebarListItems:["Student's Routine"],
            sidebarExpanded:true,
            lightTheme:false
        }
    },
    methods:{
        onSidebarItemSelected(x){
            this.active = x ;
            bus.$emit(x,x);
        },
        CollapseAndExpandSidebar(){
            if( this.sidebarExpanded ){
                this.sidebarExpanded=false;
            }else{
                this.sidebarExpanded=true;
            }
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
    },
    created(){
        /** Fetch Theme **/
        this.FetchTheme();
        bus.$on('ThemeChanged',x=>{this.FixTheme(x)})
        bus.$on("SigninStudent",x   => {this.active = 'Student'})
    }
}
</script>

<style lang="scss" scoped>
    #sidebar{
        width: 13rem;
        height: 100vh;
        position: relative;
        transition: all 0.3s ease-in-out;
    }
    .sd-con{
        transition: all 0.3s ease-in-out;
        //transition-delay: 0.3s;
        opacity: 1;
        visibility: visible;
    }
    .sidebar-collapse{
        width: 0 !important;
        .sd-con,.box-note{
            visibility: hidden;
            opacity: 0;
            position: absolute;
            left: -12rem;
        }
    }
    .sidebar-top{
        //height: 8rem;
        .back{
            position:absolute;
            overflow: hidden;
            background-color:#191919;
            top: 0.5rem;right: 0;
            width: 3rem;height: 3rem;
            cursor: pointer;
            border-top-left-radius: 2rem;
            border-bottom-left-radius: 2rem;
            transition: all 0.3s ease-in-out;
            img{
                position: absolute;
                transition: all 0.3s ease-in-out;
                width: 0.8rem;top: 50%;left: 50%;
                transform: translate(-50%,-50%)
            }
        }
        .back:hover{
            background-color: #313131;
        }
        .forward{
            right: -3rem;
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
            border-top-right-radius: 2rem;
            border-bottom-right-radius: 2rem;
            background-color: #282828;
            img{
                position: absolute;
                width: 0.8rem;top: 30%;left: 40%;
                transform: rotateY(180deg)
            }
        }
    }
    ul{
        padding-left: 0;
        text-align: left;
        li{
            color: #9e9e9e;
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
            background-color:#171717; 
        }
    }
.box-note{
    margin-top: 5rem;
    p{
        font-size: 0.9em;
        margin-bottom: 0;
        color: #9e9e9e;
    }
}
// THEMEING //
.light-colors{
    background-color: #009688;
    .back{
        background-color: #e0f2f1;
    }
    .back:hover{
        background-color: #b2dfdb;
    }
    .box-note p{
        color: #e0f2f1 !important;
    }
}
.ch-bg-bg-2{
    li{
        color: #e0f2f1;
        font-weight: 400;
    }
    li:hover,.active{
        background-color:#00796b;
        color: white;
    }
}
</style>
