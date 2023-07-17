import axios, { AxiosResponse } from "axios";
import { API_URL } from '/layout/AppConfig';
import {BaseCriteria} from "/pages/zynerator/criteria/BaseCriteria.model";
import {PaginatedList} from "/pages/zynerator/dto/PaginatedList.model";
import {BaseDto} from "/pages/zynerator/dto/BaseDto.model";
import {${pojo.name}Dto} from '/pages/controller/model/${pojo.name}.model';
import {${pojo.name?cap_first}Criteria} from "/pages/controller/criteria/${pojo.name?cap_first}Criteria.model";



export const ${pojo.name}Service = {

   getList(): Promise<AxiosResponse<${pojo.name}Dto[]>> {
     return axios.get(API_URL + '${pojo.name?uncap_first}/');
   },

   save(item: ${pojo.name}Dto): Promise<AxiosResponse<${pojo.name}Dto>> {
     return axios.post(API_URL + '${pojo.name?uncap_first}/', item);
   },

   update(item: ${pojo.name}Dto): Promise<AxiosResponse<${pojo.name}Dto>> {
      return axios.put(API_URL + '${pojo.name?uncap_first}/', item);
   },

   delete(id: number): Promise<AxiosResponse<${pojo.name}Dto>> {
      return axios.delete(API_URL + '${pojo.name?uncap_first}/id/'+ id);
   },

   deleteList(items: ${pojo.name}Dto[]): Promise<AxiosResponse<string>> {
      return axios.post(API_URL + '${pojo.name?uncap_first}/multiple', items);
   },

   findPaginatedByCriteria(criteria:${pojo.name}Criteria):Promise<AxiosResponse<PaginatedList<${pojo.name}Dto>>> {
     return axios.post<PaginatedList<${pojo.name}Dto>>(API_URL + '${pojo.name?uncap_first}/find-paginated-by-criteria', criteria);
   }
};

