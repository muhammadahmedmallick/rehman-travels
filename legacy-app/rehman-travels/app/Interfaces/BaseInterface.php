<?php

namespace App\Interfaces;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;

interface BaseInterface {
    /**
     * Get all models.
     * @param array $columns
     * @param array $relations
     * @return Collection
     */
    public function all(array $columns = ['*'], array $relations = []): Collection;

    /**
     * Find model by id.
     * @param int $modelId
     * @param array $columns
     * @param array $relations
     * @param array $appends
     * @return Model
     */
    public function findById(int $modelId, array $columns = ['*'], array $relations = [], array $appends = []): ?Model;

    public function find(int $modelId, array $columns = ['*'], array $relations = [], array $appends = []): ?Model;

    /**
     * Create a model.
     * @param array $data
     * @return Model
     */
    public function store(array $data = []): ?Model;
    /**
     * Update existing model.
     * @param int $modelId
     * @param array $data
     * @return bool
     */
    public function update(int $modelId, array $data = []);
    /**
     * find delete model by id.
     * @param int $modelId
     * @return Model
     */
    public function delete(int $modelId): ?bool;

    /**
     * @param array data
     * @return Model
     */
    public function with(array $data): ?Model;
    /**
     * @param int $id
     * @return Model
     */
    public function findOrFail(int $modelId): ?Model;

    public function findBySlug($slug): ?Model;

    public function query():?Model;

    public function instance(array $attributes = []):?Model;

    public function paginate($limit = null, $columns = ['*']):?Model;

    public function where($key, $where):Collection;

    public function whereWithRelation($key, $where, $relations= []):Collection;
    
 
    

}
