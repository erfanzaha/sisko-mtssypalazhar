<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class M_post_categories extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'categories';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->where('category_type', 'post');
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('category_name', $keyword);
			$this->db->or_like('category_description', $keyword);
			$this->db->or_like('category_slug', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table);
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table);
	}

	/**
	 * Get All Post Categories
	 * @param Integer $limit
	 * @return Resource
	 */
	public function get_post_categories($limit = 0) {
		$this->db->where('category_type', 'post');
		$this->db->where('is_deleted', 'false');
		if ( $limit > 0 ) $this->db->limit($limit);
		return $this->db->get(self::$table);
	}

	/**
	 * Row Array
	 * @return Array
	 */
	public function row_array() {
		$query = $this->get_post_categories();
		$data = [];
		foreach($query->result() as $row) {
			$data[$row->id] = $row->category_name;
		}
		return $data;
	}

	/**
	 * custom Save
	 * @param Array
	 * @return Integer
	 */
	public function save($dataset) {
		$query = $this->db->insert(self::$table, $dataset);
		return $query ? $this->db->insert_id() : 0;
	}
}
