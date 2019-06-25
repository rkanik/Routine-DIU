<template>
    <div class="container">
        <table v-bind:class="{'light-colors':lightTheme}">
            <thead v-if="d.Routine.Saturday.length > 0 || d.Routine.Sunday.length > 0 || 
                d.Routine.Monday.length > 0 || d.Routine.Tuesday.length > 0 ||
                d.Routine.Wednesday.length > 0 || d.Routine.Thursday.length > 0">
                <tr><th>Day/Time</th><th>{{d.slots[0]}}</th><th>{{d.slots[1]}}</th>
                <th>{{d.slots[2]}}</th><th>{{d.slots[3]}}</th><th>{{d.slots[4]}}</th>
                <th>{{d.slots[5]}}</th></tr>
            </thead>
            <tbody>
                <tr v-if="d.Routine.Saturday.length > 0">
                    <th>Saturday</th>
                    <td v-for="el in d.Routine.Saturday" v-bind:key="el.Time">
                        <p>{{el.Course}}</p>
                        <p>{{el.Teacher}}</p>
                        <p>{{el.Room}}</p>
                    </td>
                </tr>
                <!-- <tr v-if="d.Routine.Sunday.length > 0"> -->
                <tr v-if="d.Routine.Sunday.length > 0">
                    <th>Sunday</th>
                    <td v-for="el in d.Routine.Sunday" v-bind:key="el.Time">
                        <p>{{el.Course}}</p>
                        <p>{{el.Teacher}}</p>
                        <p>{{el.Room}}</p>
                    </td>
                </tr>
                <tr v-if="d.Routine.Monday.length > 0">
                    <th>Monday</th>
                    <td v-for="el in d.Routine.Monday" v-bind:key="el.Time">
                        <p>{{el.Course}}</p>
                        <p>{{el.Teacher}}</p>
                        <p>{{el.Room}}</p>
                    </td>
                </tr>
                <tr v-if="d.Routine.Tuesday.length > 0">
                    <th>Tuesday</th>
                    <td v-for="el in d.Routine.Tuesday" v-bind:key="el.Time">
                        <p>{{el.Course}}</p>
                        <p>{{el.Teacher}}</p>
                        <p>{{el.Room}}</p>
                    </td>
                </tr>
                <tr v-if="d.Routine.Wednesday.length > 0">
                    <th>Wednesday</th>
                    <td v-for="el in d.Routine.Wednesday" v-bind:key="el.Time">
                        <p>{{el.Course}}</p>
                        <p>{{el.Teacher}}</p>
                        <p>{{el.Room}}</p>
                    </td>
                </tr>
                <tr v-if="d.Routine.Thursday.length > 0">
                    <th>Thursday</th>
                    <td v-for="el in d.Routine.Thursday" v-bind:key="el.Time">
                        <p>{{el.Course}}</p>
                        <p>{{el.Teacher}}</p>
                        <p>{{el.Room}}</p>
                    </td>
                </tr>
            </tbody>
        </table>
        <div v-if="d.Routine.Labs.length > 0">
            <div class="card" v-bind:class="{'light-card':lightTheme}" v-for="el in d.Routine.Labs" v-bind:key="el.Time">
                <div class="card-body row">
                    <div class="col-md-3">
                        <label class="text-accent">Course title</label>
                        <p class="card-title">{{el.Title}}</p>
                    </div>
                    <div class="col-md-2">
                        <label class="text-accent">Day</label>
                        <p class="card-title">{{el.Day}}</p>
                    </div>
                    <div class="col-md-2">
                        <label class="text-accent">Time</label>
                        <p class="card-title">{{el.Time}}</p>
                    </div>
                    <div class="col-md-2">
                        <label class="text-accent">Teacher</label>
                        <p class="card-title">{{el.Teacher}}</p>
                    </div>
                    <div class="col-md">
                        <label class="text-accent">Room</label>
                        <p class="card-title">{{el.Room}}</p>
                    </div>
                    <div class="col-md">
                        <label class="text-accent">Code</label>
                        <p class="card-title">{{el.Course}}</p>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="d.Routine.Friday.length > 0">
            <div class="card" v-bind:class="{'light-card':lightTheme}" v-for="el in d.Routine.Friday" v-bind:key="el.Time">
                <div class="card-body row">
                    <div class="col-md-3">
                        <label class="text-accent">Course title</label>
                        <p class="card-title">{{el.Title}}</p>
                    </div>
                    <div class="col-md-2">
                        <label class="text-accent">Code</label>
                        <p class="card-title">{{el.Course}}</p>
                    </div>
                    <div class="col-md-2">
                        <label class="text-accent">Day</label>
                        <p class="card-title">{{el.Day}}</p>
                    </div>
                    <div class="col-md-2">
                        <label class="text-accent">Time</label>
                        <p class="card-title">{{el.Time}}</p>
                    </div>
                    <div class="col-md">
                        <label class="text-accent">Room</label>
                        <p class="card-title">{{el.Room}}</p>
                    </div>
                    <div class="col-md">
                        <label class="text-accent">Teacher</label>
                        <p class="card-title">{{el.Teacher}}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { bus } from "../../main";
export default {
    name: "TableView",
    props:{
        d:{}
    },
    data(){
        return{
            lightTheme:false,
        }
    },
    created(){

        /** Fetch Theme **/
        this.FetchTheme();
        bus.$on('ThemeChanged',x=>{this.FixTheme(x)});

    },
    methods:{
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
};
</script>
<style lang="scss" scoped>
table{
    width: 100%;
    margin: 1rem 0;
    border-collapse: collapse;
    thead{
        tr{
            background-color: #006064;
        }
        th{
            padding: 0.4rem 0 0.4rem 1rem;
            font-size: 1em;
            font-weight: 500;
            color: #bdbdbd;
            border-right: 1px solid #313131;
        }
        th:last-child{
            border-right-color: #006064;
        }th:first-child{
            border-left: 1px solid #006064;
        }
    }
    tbody{
        tr{
            background-color: #191919;
        }
        td,th{
            padding: 0.6rem 0 0.6rem 1rem;
            border: 1px solid #202020;
            p{
                margin: 0 ;
                font-weight: 300;
                font-size: 15px;
            }
        }
    }
}
.card{
    background-color: #191919;
    padding: 0 0.5rem;
    margin-bottom: 1rem;
    border: 1px solid #202020;
    .card-title,label{
        margin-bottom: 0;
    }
    label{
        font-size: 0.9em;
    }
}

.light-colors{
    thead{
        tr{
            background-color: #009688;
        }
        th{
            color: white;
            border-right: 1px solid #f5f5f5;
        }
        th:last-child{
            border-right-color: #009688;
        }th:first-child{
            border-left: 1px solid #009688;
        }
    }
    tbody{
        tr{
            background-color: white;
        }
        td,th{
            border: 1px solid #dfdfdf;
            color: #424242;
            font-weight: 400;
            p{
                color: #424242;
                font-weight: 400;
            }
        }
    }  
}
.light-card{
    background-color: white !important;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.1);
    border: none;
    .card-title{
        color: #424242;
    }
}
</style>
