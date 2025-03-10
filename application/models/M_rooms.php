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

class M_rooms extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'rooms';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select('x1.id, x2.option_name AS building_name, x1.room_name, x1.room_capacity, x1.is_class_room, x1.is_deleted');
		$this->db->join('options x2', 'x1.building_id = x2.id', 'LEFT');
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x2.building_name', $keyword);
			$this->db->or_like('x1.room_name', $keyword);
			$this->db->or_like('x1.room_capacity', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Dropdown
	 * @return Array
	 */
	public function dropdown() {
		$query = $this->db
			->select('id, room_name')
			->where('is_deleted', 'false')
			->get(self::$table);
		$data = [];
		if ($query->num_rows() > 0) {
			foreach($query->result() as $row) {
				$data[$row->id] = $row->room_name;
			}
		}
		return $data;
	}
}
