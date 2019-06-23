<template>
    <div class="StudList">
        <div class="container">
            <table class="table">
                <thead>
                    <tr class="bg-teal-7 grey-2">
                        <th>No.</th>
                        <th>Students name</th>
                        <th>Student ID</th>
                        <th>Section</th>
                        <th>Semester</th>
                        <th>Last visited</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="bg-grey-9 grey-5" v-for="s in data.s" v-bind:key="s.ID">
                        <td scope="row">{{s.index}}</td>
                        <td>{{s.Name}}</td>
                        <td>{{s.ID}}</td>
                        <td>{{s.Section}}</td>
                        <td>{{s.Level}}{{s.Term}}</td>
                        <td>{{s.LastVisited}}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="container">
            <nav>
                <ul class="pagination">
                    <li class="item prev" @click="GetStudentsAt(data.pages.current-1)" v-bind:class="{disabled:data.pages.current==1}">Previous</li>
                    <li class="item" v-if="data.pages.nprev>0" @click="GetStudentsAt(data.pages.nprev)">{{data.pages.nprev}}</li>
                    <li class="item" v-if="data.pages.prev>0" @click="GetStudentsAt(data.pages.prev)">{{data.pages.prev}}</li>
                    <li class="item active" @click="GetStudentsAt(data.pages.current)">{{data.pages.current}}</li>
                    <li class="item" v-if="data.pages.next <= data.pages.last" @click="GetStudentsAt(data.pages.next)">{{data.pages.next}}</li>
                    <li class="item" v-if="data.pages.nnext <= data.pages.last" @click="GetStudentsAt(data.pages.nnext)">{{data.pages.nnext}}</li>
                    <li class="item next" @click="GetStudentsAt(data.pages.current+1)"  v-bind:class="{disabled:data.pages.current==data.pages.last}">Next</li>
                </ul>
            </nav>
        </div>
    </div>
</template>

<script>

/** IMPORTS */
import { bus } from "../../main";

/** COMPONENTS */

export default {
    name:'',
    props:{
        data:{}
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
        GetStudentsAt( pageNo ){
            bus.$emit('GetStudentsAt',pageNo);
        }
    },
    mounted(){

    },
    computed:{

    }
}
</script>
<style lang="scss" scoped>
    .StudList{
        padding: 0.8rem;
    }
    .table{
        border-collapse: collapse;
        
        th{
            border: none;
        }
        td,th{
            border: 1px solid #282828;
            font-weight: 300;
        }
        th{
            font-weight: 400;
        }

        th:first-child{
            border-left: none;
        }
        th:last-child{
            border-right: none;
        }
    }
    .pagination{
        .item{
            border: 1px solid #202020;
            padding: 0.3rem 0.6rem;
            background-color: #202020;
            border-right: 1px solid #282828;
            cursor: pointer;
        }
        .prev{
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
        }
        .next{
            border-top-right-radius: 4px;
            border-bottom-right-radius: 4px;
            border-right: none;
        }
        .active{
            background-color: #009688;
            color: white
        }
        .item:hover{
            background-color: #313131;
        }
        .disabled{
            pointer-events: none;
            color: #424242;
        }
    }
</style>
