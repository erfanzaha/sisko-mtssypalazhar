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

class M_class_group_students extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'class_group_students';

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
			x1.id
			, x2.academic_year
			, CONCAT(x3.class_group, IF((x4.major_short_name <> ''), CONCAT(' ',x4.major_short_name),''),IF((x3.sub_class_group <> ''),CONCAT(' - ',x3.sub_class_group),'')) AS class_group
			, COALESCE(x5.nis, '') AS nis
			, COALESCE(x5.nisn, '') AS nisn
			, x5.full_name
			, x5.gender
			, COALESCE(x5.birth_place, '') AS birth_place
			, COALESCE(x5.birth_date, '') AS birth_date
			,	x1.is_deleted
			");
		$this->db->join('academic_years x2', 'x1.academic_year_id = x2.id', 'LEFT');
		$this->db->join('class_groups x3', 'x1.class_group_id = x3.id', 'LEFT');
		$this->db->join('majors x4', 'x3.major_id = x4.id', 'LEFT');
		$this->db->join('users x5', 'x1.student_id = x5.id', 'LEFT');
		$this->db->where('x5.is_student', 'true');
		$this->db->where('x5.is_alumni', 'false');
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x2.academic_year', $keyword);
			$this->db->or_like("CONCAT(x3.class_group, IF((x4.major_short_name <> ''), CONCAT(' ',x4.major_short_name),''),IF((x3.sub_class_group <> ''),CONCAT(' - ',x3.sub_class_group),''))", $keyword);
			$this->db->or_like('x5.nis', $keyword);
			$this->db->or_like('x5.nisn', $keyword);
			$this->db->or_like('x5.full_name', $keyword);
			$this->db->or_like('x5.gender', $keyword);
			$this->db->or_like('x5.birth_place', $keyword);
			$this->db->or_like('x5.birth_date', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Get Students
	 * @param Integer $academic_year_id
	 * @param Integer $class_group_id
	 * @return Resource
	 */
	public function get_students($academic_year_id, $class_group_id) {
		// Get "Aktif" Student Status ID
		$student_status_id = get_option_id('student_status', 'aktif');
		if ($class_group_id == 'unset') {
			$student_ids = $this->db
				->select('student_id')
				->from('class_group_students')
				->group_by('student_id')
				->get_compiled_select();
			$query = $this->db
				->select('id, nis, full_name')
				->where('id NOT IN(' . $student_ids . ')')
				->where('is_student', 'true')
				->where('is_alumni', 'false')
				->where('student_status_id', _toInteger($student_status_id))
				->get('users');
		} else if ($class_group_id == 'show_all') {
			$query = $this->db
				->select('id, nis, full_name')
				->where('is_student', 'true')
				->where('is_alumni', 'false')
				->where('student_status_id', _toInteger($student_status_id))
				->get('users');
		} else {
			$class_group_setting = $this->db
				->select('id')
				->where('academic_year_id', $academic_year_id)
				->where('class_group_id', $class_group_id)
				->get('class_group_settings');
			if ($class_group_setting->num_rows() === 1) {
				$res = $class_group_setting->row();
				$class_group_setting_id = $res->id;
				$query = $this->db
					->select('x2.id, x2.nis, x2.full_name')
					->join('users x2', 'x1.student_id = x2.id', 'LEFT')
					->where('x1.class_group_setting_id', $class_group_setting_id)
					->where('x1.is_deleted', 'false')
					->where('x2.is_deleted', 'false')
					->where('x2.is_alumni', 'false')
					->where('x2.is_student', 'true')
					->get(self::$table.' x1');
			}
		}

		$data = [];
		if (isset($query) && is_object($query)) {
			foreach($query->result() as $row) {
				$data[] = [
					'id' => $row->id,
					'nis' => $row->nis,
					'full_name' => $row->full_name
				];
			}
		}
		return $data;
	}

	/**
	 * Set Class Group Students
	 * @param Integer $student_ids
	 * @param Integer $academic_year_id
	 * @param Integer $class_group_id
	 * @return Boolean
	 */
	public function set_class_group_students($student_ids, $academic_year_id, $class_group_id) {
		// Get Active student Status ID
		$student_status_id = get_option_id('student_status', 'aktif');
		// Get Class Group Setting
		$class_group_setting_id = 0;
		$query = $this->db
			->select('id')
			->where('academic_year_id', $academic_year_id)
			->where('class_group_id', $class_group_id)
			->get('class_group_settings');
		if ($query->num_rows() === 1) {
			$res = $query->row();
			$class_group_setting_id = $res->id;
		}
		$success = 0;
		if ($class_group_setting_id > 0) {
			foreach ($student_ids as $student_id) {
				$this->db->set('student_id', $student_id);
				$this->db->set('class_group_setting_id', $class_group_setting_id);
				$this->db->set('created_by', (int) __session('user_id'));
				$query = $this->db->insert(self::$table);
				if ( $query ) {
					// if Success, update student status to "Aktif"
					$this->db->where('id', $student_id)->update('users', ['student_status_id' => $student_status_id]);
					$success++;
				}
			}
		}
		return $success > 0;
	}

	/**
	 * Delete Permanently
	 * @param Array $ids
	 * @param Integer $academic_year_id
	 * @param Integer $class_group_ide
	 * @return Boolean
	 */
	public function delete_permanently($ids, $academic_year_id, $class_group_id) {
		$class_group_setting_id = 0;
		$query = $this->db
			->select('id')
			->where('academic_year_id', $academic_year_id)
			->where('class_group_id', $class_group_id)
			->get('class_group_settings');
		if ($query->num_rows() === 1) {
			$res = $query->row();
			$class_group_setting_id = $res->id;
		}
		return $this->db
			->where('class_group_setting_id', $class_group_setting_id)
			->where_in('student_id', $ids)
			->delete(self::$table);
	}
}
