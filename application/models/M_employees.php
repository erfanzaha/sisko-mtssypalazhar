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

class M_employees extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'users';

	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select("
			x1.*
			, x2.option_name AS employment_type
			, IF(x1.gender = 'M', 'L', 'P') AS gender
			, COALESCE(x1.birth_place, '') birth_place
		");
		$this->db->join('options x2', 'x1.employment_type_id = x2.id', 'LEFT');
		$this->db->where('x1.is_employee', 'true');
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x1.nik', $keyword);
			$this->db->or_like('x1.full_name', $keyword);
			$this->db->or_like('x1.gender', $keyword);
			$this->db->or_like('x1.birth_place', $keyword);
			$this->db->or_like('x1.birth_date', $keyword);
			$this->db->or_like('x1.email', $keyword);
			$this->db->or_like('x2.option_name', $keyword);
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
			->select('id, nik, full_name')
			->where('is_deleted', 'false')
			->order_by('full_name', 'ASC')
			->get(self::$table);
		$data = [];
		if ($query->num_rows() > 0) {
			foreach($query->result() as $row) {
				$data[$row->id] = $row->nik .' - '. $row->full_name;
			}
		}
		return $data;
	}

	/**
	 * Get Employment Type
	 * @param Integer $id
	 * @return String
	 */
	public function get_employment_type($id) {
		$query = $this->model->RowObject(self::$pk, $id, self::$table);
		if (is_object($query)) {
			$employment_type = $this->model->RowObject('id', $query->employment_type_id, 'options');
			if (is_object($employment_type)) {
				return $employment_type->option_name;
			}
			return NULL;
		}
		return NULL;
	}

	/**
	 * Employee Query
	 * @return String
	 */
	public function employee_query() {
		return "
		SELECT x1.*
			, IF(x1.gender = 'M', 'L', 'P') AS gender
			, x2.option_name AS religion
			, x3.option_name AS employment_type
		FROM users x1
		LEFT JOIN options x2 ON x1.religion_id = x2.id
		LEFT JOIN options x3 ON x1.employment_type_id = x3.id
		WHERE is_employee = 'true'";
	}

	/**
	 * Employee Reports
	 * @return Resource
	 */
	public function employee_reports() {
		$query = $this->employee_query();
		$query .= "
		ORDER BY x1.full_name ASC";
		return $this->db->query($query);
	}

	/**
	 * Profile
	 * @param Integer $id
	 * @return Resource
	 */
	public function profile($id) {
		$query_string = $this->employee_query();
		$query_string .= '
			AND x1.id = ?
		';
		return $this->db->query($query_string, [_toInteger( $id )])->row();
	}

	/**
	 * Get Employees
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_employees($limit = 0, $offset = 0) {
		$this->db->select("
			x1.*
		  , IF(x1.gender = 'M', 'Laki-laki', 'Perempuan') as gender
		  , x2.option_name AS employment_type
		");
		$this->db->join('options x2', 'x1.employment_type_id = x2.id', 'LEFT');
		$this->db->where('x1.is_deleted', 'false');
		$this->db->where('x1.is_employee', 'true');
		$this->db->order_by('x1.full_name', 'ASC');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}
}
