<?php

namespace App\Services;

use App\Interfaces\BaseInterface;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

class BaseService implements BaseInterface {
    /**
     * @var Model
     */
    protected $model;
    /**
     * UserService constructor.
     *
     * @param Model $model
     */
    public function __construct(Model $model){
        $this->model = $model;
    }

    public function all(array $columns = ['*'], array $relations = []): Collection
    {
        return $this->model->with($relations)->get($columns);
    }

    public function find(int $modelId,array $columns = ['*'],array $relations = [],array $appends = []): ?Model {
        return $this->model->select($columns)->find($modelId);
    }

    public function findById(int $modelId,array $columns = ['*'],array $relations = [],array $appends = []): ?Model {
        return $this->model->select($columns)->with($relations)->findOrFail($modelId)->append($appends);
    }

    /**
     * @param array $data
     * @return Model
     */
    public function store(array $data = []): ? Model {
        $model = $this->model->create($data);
        return $model->fresh();
    }

    /**
     * @param integer $id
     * @param array $data
     * @return Model
     */
    public function update(int $id, array $data = []) {
        $model = $this->find($id);
        $model->update($data);
        return $model->fresh();
    }

    /**
     * @param integer $id
     * @return Model
     * @throws \Exception
     */
    public function delete(int $id): ?bool {
        return $this->find($id)->delete();
    }


    public function with(array $array): ? Model {
        return $this->model->with($array);
    }

    /**
     * @param integer $id
     * @return Model
     * @throws ModelNotFoundException
     */
    public function findOrFail(int $id): ? Model {
        return $this->model->findOrFail($id);
    }

    /**
     * @param string $slug
     * @return Model
     * @throws ModelNotFoundException
     */
    public function findBySlug($slug): ? Model {
        return $this->model->where('slug', $slug)->first();
    }

    /**
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query(): ? Model {
        return $this->model->query();
    }

    /**
     * @param array $attributes
     * @return Model
     */
    public function instance(array $attributes = []): ? Model {
        $model = $this->model;
        return new $model($attributes);
    }

    /**
     * @param int|null $perPage
     * @return mixed
     */
    public function paginate($limit = null, $columns = ['*']) : ? Model{
        return $this->model->paginate($limit);
    }

    public function where($key, $where) : Collection{
        return $this->model->where($key, $where)->get('*');
    }

    public function whereQuery($where) : Collection{
        return $this->model->where($where)->get('*');
    }

    public function fetch($where){
        return $this->model->where($where)->first('*');
    }
    
    public function fetchWithRelation($key, $where, $relations = []){
        return $this->model->with($relations)->where($key, $where)->first('*');
    }
    
    public function single($where){
        return $this->model->where($where)->first('*');
    }

    public function whereLimit($whereInKey = '', $whereInValue = '',$where = []){
        return $this->model->whereIn($whereInKey, $whereInValue)->where($where)->orderBy('categories', 'DESC')->get();
    }

    public function whereInRelation($whereInKey = '', $whereInValue = '', $relations = []){
        return $this->model->with($relations)->whereIn($whereInKey, $whereInValue)->orderBy('categories', 'DESC')->get();
    }

    public function whereWithRelation($key, $where, $relations = []) : Collection{
        return $this->model->with($relations)->where($key, $where)->get('*');
    }

    public function whereRelation($where = [], $relations = []) : Collection{
        return $this->model->with($relations)->where($where)->get('*');
    }

    public function allOrderBy(array $columns = ['*'], array $relations = [], $orderByField, $orderByType): Collection
    {
        return $this->model->with($relations)->orderBy($orderByField, $orderByType)->get($columns);
    }
    public function whereCallBackRelation($where = [], $relations = [], $orderByField, $orderByType) : Collection{
        return $this->model->with($relations)->where($where)->orderBy($orderByField, $orderByType)->get('*');
    }
    public function whereInWhereRelation($whereInKey = '', $whereInValue = '',$where = [], $relations = [])
    {
        return $this->model->with($relations)->whereIn($whereInKey, $whereInValue)->where($where)->orderBy('id', 'DESC')->get();
    }
    
    public  function __destruct() {
        DB::disconnect();
    }
}
