<?php defined('BASEPATH') or exit('No direct script access allowed');


class M_grade extends CI_Model
{
	public static $pk = 'id';

	public static $table = 'grade';

	public function insert($course_class_id)
	{

		$from = $this->db->get_where('course_classes', [
			'id' => $course_class_id
		])->row();

		$students = $this->db
			->select('x1.student_id')
			->join('class_group_settings x2', 'x1.class_group_setting_id = x2.id', 'LEFT')
			->join('users x3', 'x1.student_id = x3.id', 'LEFT')
			->where('x2.academic_year_id', $from->academic_year_id)
			->where('x2.class_group_id', $from->class_group_id)
			->get('class_group_students x1');

		foreach ($students->result() as $row) {
			if (! $this->is_exists($from->class_meeting_id, $row->student_id)) {
				$dataset = [
					'subjects_id' => (int)$from->subject_id,
					'employees_id' => (int)$from->employee_id,
					'class_groups_id' => (int)$from->class_group_id,
					'students_id' => (int)$row->student_id,
					'academic_years_id' => (int)$from->academic_year_id,
					'assignment_score' => 0,
					'mid_score' => 0,
					'exam_score' => 0,
					'created_at' => date("Y-m-d H:i:s"),
					'updated_at' => null,
				];
				$this->db->insert('grade', $dataset);
			}
		}
		return $dataset;
	}

	public function update($grade)
	{
		$success = 0;
		foreach ($grade as $row) {
			$dataset = [
				'updated_at' => date("Y-m-d H:i:s"),
				'assignment_score' => $row['assignment_score'],
				'mid_score' => $row['mid_score'],
				'exam_score' => $row['exam_score'],
			];
			$id = $row['id'];
			$query = $this->db
				->where('id', $id)
				->update(self::$table, $dataset);
			if ($query) {
				$success++;
			}
		}
		return $success > 0;
	}

	public function is_exists($course_class_id)
	{
		$from = $this->db->get_where('course_classes', [
			'id' => $course_class_id
		])->row();

		$count = $this->db
			->where('class_groups_id', $from->class_group_id)
			->count_all_results(self::$table);
		return $count >= 1;
	}

	public function get_grade_attendences($course_class_id)
	{

		$from = $this->db->get_where('course_classes', [
			'id' => $course_class_id
		])->row();

		$query = $this->db
			->select("
				x1.id
				, x2.nis
				, x2.full_name
				, IF(x2.gender = 'M', 'L', 'P') AS gender
				, x1.mid_score
				, x1.assignment_score
				, x1.exam_score
			")
			->join('users x2', 'ON x1.students_id = x2.id', 'LEFT')
			->where('x1.class_groups_id', $from->class_group_id)
			->get(self::$table . ' x1');
		$data = [];
		foreach ($query->result() as $row) {
			$data[] = [
				'id'        	   => $row->id,
				'nis'       	   => $row->nis,
				'full_name'        => $row->full_name,
				'gender'           => $row->gender,
				'assignment_score' => $row->assignment_score,
				'mid_score' 	   => $row->mid_score,
				'exam_score' 	   => $row->exam_score,
			];
		}
		return $data;
	}

	public function student_grade_report($keyword = '', $return_type = 'count', $limit = 0, $offset = 0)
	{
		$this->db->select("
		x1.id,
		x2.subject_name,
		x3.full_name,
		x4.class_group,
		x4.sub_class_group,
		x5.academic_year,
		IF(x5.semester = 'odd', 'Ganjil', 'Genap') as semester,
		x1.assignment_score,
		x1.mid_score,
		x1.exam_score
		");
		$this->db->join('subjects x2', 'x2.id = x1.subjects_id', 'LEFT');
		$this->db->join('users x3', 'x3.id = x1.employees_id', 'LEFT');
		$this->db->join('class_groups x4', 'x4.id = x1.class_groups_id', 'LEFT');
		$this->db->join('academic_years x5', 'x5.id = x1.academic_years_id', 'LEFT');

		$this->db->where('x1.students_id', (int) __session('user_id'));
		if (! empty($keyword)) {
			$this->db->group_start();
			$this->db->or_like('x2.subject_name', $keyword);
			$this->db->or_like('x3.full_name', $keyword);
			$this->db->or_like('x4.class_group', $keyword);
			$this->db->or_like('x4.sub_class_group', $keyword);
			$this->db->or_like('x5.academic_year ', $keyword);
			$this->db->group_end();
		}
		$this->db->order_by('x1.id', 'ASC');
		if ($return_type === 'count') return $this->db->count_all_results(self::$table . ' x1');
		if ($limit > 0) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}
}
