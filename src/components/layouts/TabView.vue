<template>
    <div class="tab-view" v-bind:class="{'light-colors':lightTheme}">
        <div class="container">
            <div class="row">
                <div class="col-md-2 on-phone-cards">
                    <ul class="ul-tab">
                        <li class="tab" v-if="d.r[d.d[6]]" @click="onTabSelected(d.d[6])" v-bind:class="{active:dayOfWeek===d.d[6]}">{{d.d[6]}}</li>
                        <li class="tab" v-if="d.r[d.d[0]]" @click="onTabSelected(d.d[0])" v-bind:class="{active:dayOfWeek===d.d[0]}">{{d.d[0]}}</li>
                        <li class="tab" v-if="d.r[d.d[1]]" @click="onTabSelected(d.d[1])" v-bind:class="{active:dayOfWeek===d.d[1]}">{{d.d[1]}}</li>
                        <li class="tab" v-if="d.r[d.d[2]]" @click="onTabSelected(d.d[2])" v-bind:class="{active:dayOfWeek===d.d[2]}">{{d.d[2]}}</li>
                        <li class="tab" v-if="d.r[d.d[3]]" @click="onTabSelected(d.d[3])" v-bind:class="{active:dayOfWeek===d.d[3]}">{{d.d[3]}}</li>
                        <li class="tab" v-if="d.r[d.d[4]]" @click="onTabSelected(d.d[4])" v-bind:class="{active:dayOfWeek===d.d[4]}">{{d.d[4]}}</li>
                        <li class="tab" v-if="d.r[d.d[5]]" @click="onTabSelected(d.d[5])" v-bind:class="{active:dayOfWeek===d.d[5]}">{{d.d[5]}}</li>
                    </ul>
                </div>
                <div class="col-md-10 on-phone-cards">
                    <div class="row">
                        <div class="card mr-3 mb-3 col-md-3" v-for="r in d.r[dayOfWeek]" v-bind:key="r.Rime">
                            <div class="card-body">
                            <p class="card-text">{{r.Time}}</p>
                            <hr>
                            <h4 class="card-title">{{r.Title}}</h4>
                            <p class="card-text">{{r.Course}}</p>
                            <p class="card-text">{{r.Teacher}}</p>
                            <hr>
                            <p class="card-text">{{r.Room}}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>

/** IMPORTS */
import {bus} from "../../main"

export default {
    name:'TabView',
    props:{
        d:Object
    },
    data(){
        return{

            /** Booleans */
            lightTheme:false,

            /** Strings */
            dayOfWeek:this.d.dow
        }
    },
    created(){
        this.FetchTheme();
        bus.$on("ThemeChanged", x => { this.FixTheme(x)})
    },
    methods:{
        onTabSelected(day){
            this.dayOfWeek=day;
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
}
</script>
<style lang="scss" scoped>
    .tab-view{
        margin-top: 1rem;
        .ul-tab {
            padding-left: 0;
            .tab {
                list-style-type: none;
                margin-bottom: 0.5rem;
                padding: 0.34rem 0 0.3rem 1rem;
                border-radius: 2rem;
                cursor: pointer;
                color: #616161;
                user-select: none;
            }
            .active,
            .tab:hover {
                background-color: #202020;
                color: #a0a0a0;
            }
        }
        .card {
            background-color: #202020;
            padding: 0 0.5rem;
            border: none;
            min-width: 14rem;
            .card-title {
                font-weight: 400;
            }
            hr {
                margin: 0.5rem 0;
                border-color: #1a1a1a;
            }
        }
    }
    .light-colors{
        .ul-tab {
            background-color: white !important;
            .tab {
                color: #313131 !important;
            }
            .active,
            .tab:hover {
                background-color: white;
                color: #313131;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.1);
            }
        }
        .card {
            background-color: white;
            border: none;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.1);
            hr {
                border-color: #e0e0e0;
            }
            .card-title {
                color: #313131;
            }
            .card-text {
                color: #424242;
            }
        }
    }

@media (max-width: 576px) {
    .on-phone-cards{
        .row{
            padding-left: 1rem;
            padding-right: 1rem;
            .col-md-3{
                margin-right: 0 !important;
            }
        }
        .ul-tab{
            width: 100%;border-radius: 4px;
            overflow: hidden;padding: 0.5rem;
            background-color: #212121;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05), 0 1px 2px rgba(0, 0, 0, 0.1);
            .tab{
                width: min-content;
                float: left;padding: 0;margin: 0.2rem 0.5rem;
                padding: 0.2rem 0.5rem;
                color: #bdbdbd
            }
            .active,
            .tab:hover {
                background-color: transparent;
                color: #bdbdbd;
                box-shadow: none;
                border: 1px solid #009688;
            }
        }
        .card:last-child{
            margin-bottom: 0 !important;
        }
    }
}

</style>
